/*CL2006 - DATABASE SYSTEMS - LAB 6 - BAI-4A - 24K-0017*/

-- Lab 6 - START

-- Q1) Solve the Queries below using subquery
/*Find employees who were hired after the latest hired employee from department 60*/

-- a)
SELECT *
FROM Employees
WHERE hire_date > (
    SELECT MAX(hire_date)
    FROM Employees
    WHERE department_id = 60
);

/*Display employees earning more than the average salary of Sales Representatives*/

-- b)
SELECT *
FROM Employees
WHERE salary > (
    SELECT AVG(salary)
    FROM Employees
    WHERE job_id = 'SA_REP'
);

/*Employees Working in the Same Department as Employee 103*/

-- c)
SELECT *
FROM Employees
WHERE department_id = (
    SELECT department_id
    FROM Employees
    WHERE employee_id = 103
);

/*Jobs Having Higher Min Salary Than Company Average Salary*/

-- d)
SELECT job_title, min_salary
FROM Jobs
WHERE min_salary > (
    SELECT AVG(salary)
    FROM Employees
);

/*Employees Whose Salary Is Equal to Minimum Salary of Any Department*/

-- e)
SELECT *
FROM Employees
WHERE salary IN (
    SELECT MIN(salary)
    FROM Employees
    GROUP BY department_id
);

-- Q2)

/*a. Employees Who Report to Same Manager as Employee 101*/

SELECT *
FROM Employees
WHERE manager_id = (
    SELECT manager_id
    FROM Employees
    WHERE employee_id = 101
);

/*b. Departments That Have More Than One Manager (Correlated)*/

SELECT *
FROM Departments d
WHERE (
    SELECT COUNT(DISTINCT manager_id)
    FROM Employees e
    WHERE e.department_id = d.department_id
) > 1;

/*c. Departments Where Avg Salary > Avg Salary of Dept 90*/

SELECT department_id
FROM Employees
GROUP BY department_id
HAVING AVG(salary) > (
    SELECT AVG(salary)
    FROM Employees
    WHERE department_id = 90
);

/*d. Employees Whose Salary > Median Salary*/

SELECT *
FROM Employees
WHERE salary > (
    SELECT MEDIAN(salary)
    FROM Employees
);

/*e. Employees Whose Commission > Avg Commission*/

SELECT *
FROM Employees
WHERE commission_pct > (
    SELECT AVG(commission_pct)
    FROM Employees
);

/*f. Employees in Same City as 'Marketing' Department*/

SELECT *
FROM Employees
WHERE department_id IN (
    SELECT department_id
    FROM Departments
    WHERE location_id = (
        SELECT location_id
        FROM Departments
        WHERE department_name = 'Marketing'
    )
);

/*g. Salary NOT equal to ANY in Dept 50*/

SELECT *
FROM Employees
WHERE salary NOT IN (
    SELECT salary
    FROM Employees
    WHERE department_id = 50
);

/*h. Salary Between Avg Dept 10 and 20*/

SELECT *
FROM Employees
WHERE salary BETWEEN (
    SELECT AVG(salary) FROM Employees WHERE department_id = 10
) AND (
    SELECT AVG(salary) FROM Employees WHERE department_id = 20
);

/*i. Employees Who Have Changed Jobs*/

SELECT *
FROM Employees e
WHERE EXISTS (
    SELECT 1
    FROM Job_History j
    WHERE j.employee_id = e.employee_id
);

-- Q3) 
/*Board requires employees who: 
Work in departments where average salary > company average 
Have salary greater than their department average 
Have worked more than 10 years 
Have no job history record 
Are not managers 
Write using multiple nested subqueries + EXISTS / NOT EXISTS*/

SELECT *
FROM Employees e
WHERE department_id IN (
    SELECT department_id
    FROM Employees
    GROUP BY department_id
    HAVING AVG(salary) > (SELECT AVG(salary) FROM Employees)
)
AND salary > (
    SELECT AVG(salary)
    FROM Employees
    WHERE department_id = e.department_id
)
AND MONTHS_BETWEEN(SYSDATE, hire_date)/12 > 10
AND NOT EXISTS (
    SELECT 1 FROM Job_History j
    WHERE j.employee_id = e.employee_id
)
AND employee_id NOT IN (
    SELECT DISTINCT manager_id FROM Employees
    WHERE manager_id IS NOT NULL
);

-- Q4) Display departments where there exists at least one employee earning more than company average AND at least one earning below company average.

SELECT *
FROM Departments d
WHERE EXISTS (
    SELECT 1 FROM Employees e
    WHERE e.department_id = d.department_id
    AND e.salary > (SELECT AVG(salary) FROM Employees)
)
AND EXISTS (
    SELECT 1 FROM Employees e
    WHERE e.department_id = d.department_id
    AND e.salary < (SELECT AVG(salary) FROM Employees)
);

-- Q5)
/*Management wants employees who: 
Belong to departments where total salary expense is greater than the highest salary in the company 
Earn less than department maximum but greater than department average 
Are NOT managers 
Have salary greater than ALL employees in department 30 
Work in departments located in cities where more than one department exists 
Use: ALL operator, correlated subquery, inline view, EXISTS*/

SELECT *
FROM Employees e
WHERE department_id IN (
    SELECT department_id
    FROM (
        SELECT department_id, SUM(salary) total_sal
        FROM Employees
        GROUP BY department_id
    )
    WHERE total_sal > (SELECT MAX(salary) FROM Employees)
)
AND salary < (
    SELECT MAX(salary)
    FROM Employees
    WHERE department_id = e.department_id
)
AND salary > (
    SELECT AVG(salary)
    FROM Employees
    WHERE department_id = e.department_id
)
AND employee_id NOT IN (
    SELECT manager_id FROM Employees WHERE manager_id IS NOT NULL
)
AND salary > ALL (
    SELECT salary FROM Employees WHERE department_id = 30
)
AND EXISTS (
    SELECT 1
    FROM Departments d
    WHERE d.department_id = e.department_id
    AND d.location_id IN (
        SELECT location_id
        FROM Departments
        GROUP BY location_id
        HAVING COUNT(*) > 1
    )
);

-- Q6)
/*Board is checking unstable departments. Display employees who: 
Work in departments where salary gap (MAX - MIN) is greater than company average salary 
Earn more than department median salary 
Are not the highest paid in their department 
Have never changed jobs (not in job_history) 
Work in departments where every employee earns more than 4000 
Use: ALL operator, nested aggregate subqueries, correlated logic, NOT EXISTS
*/

SELECT *
FROM Employees e
WHERE department_id IN (
    SELECT department_id
    FROM Employees
    GROUP BY department_id
    HAVING MAX(salary) - MIN(salary) > (SELECT AVG(salary) FROM Employees)
)
AND salary > (
    SELECT MEDIAN(salary)
    FROM Employees
    WHERE department_id = e.department_id
)
AND salary < (
    SELECT MAX(salary)
    FROM Employees
    WHERE department_id = e.department_id
)
AND NOT EXISTS (
    SELECT 1 FROM Job_History j
    WHERE j.employee_id = e.employee_id
)
AND department_id IN (
    SELECT department_id
    FROM Employees
    GROUP BY department_id
    HAVING MIN(salary) > 4000
);

-- Q7)
/*The company wants to shortlist “elite” employees who: 
Work in departments whose average salary is greater than company average 
Earn more than department average 
Earn less than the highest salary in company but more than ALL employees in department 20 
Have worked more years than their manager 
Belong to departments where there exists at least one employee hired after 2020 
Are not managers 
Do not exist in job_history*/

SELECT *
FROM Employees e
WHERE department_id IN (
    SELECT department_id
    FROM Employees
    GROUP BY department_id
    HAVING AVG(salary) > (SELECT AVG(salary) FROM Employees)
)
AND salary > (
    SELECT AVG(salary)
    FROM Employees
    WHERE department_id = e.department_id
)
AND salary < (SELECT MAX(salary) FROM Employees)
AND salary > ALL (
    SELECT salary FROM Employees WHERE department_id = 20
)
AND MONTHS_BETWEEN(SYSDATE, hire_date)/12 >
    (SELECT MONTHS_BETWEEN(SYSDATE, hire_date)/12
     FROM Employees
     WHERE employee_id = e.manager_id)
AND department_id IN (
    SELECT department_id
    FROM Employees
    WHERE hire_date > '01-JAN-2020'
)
AND employee_id NOT IN (
    SELECT manager_id FROM Employees WHERE manager_id IS NOT NULL
)
AND NOT EXISTS (
    SELECT 1 FROM Job_History j
    WHERE j.employee_id = e.employee_id
);

-- Q8)

/*1) Display employee names, their job titles, and the departments they belong to.*/
SELECT e.first_name, j.job_title, d.department_name
FROM Employees e
JOIN Jobs j ON e.job_id = j.job_id
JOIN Departments d ON e.department_id = d.department_id;

/*2) List all the job IDs of employees working in department 80, along with all job IDs from the Jobs table ensuring that duplicate values are removed.*/
SELECT job_id FROM Employees WHERE department_id = 80
UNION
SELECT job_id FROM Jobs;

/*3) Show all possible pairs of employee job titles for staff earning more than 15000.*/
SELECT e1.job_id, e2.job_id
FROM Employees e1, Employees e2
WHERE e1.salary > 15000 AND e2.salary > 15000;

/*4) Display all job titles along with employees assigned to them. Include all jobs but show only employees whose hire date is before 01-JAN-2010.*/
SELECT j.job_title, e.first_name
FROM Jobs j
LEFT JOIN Employees e
ON j.job_id = e.job_id
AND e.hire_date < '01-JAN-2010';

/*5) Find the department IDs that exist both in employees where salary is greater than 7000 and in departments where the location ID is 2000.*/
SELECT department_id FROM Employees WHERE salary > 7000
INTERSECT
SELECT department_id FROM Departments WHERE location_id = 2000;

/*6) Show department names, the city they are located in and the employees working there (if any). Only display employees whose commission percentage is lower than 0.15.*/
SELECT d.department_name, l.city, e.first_name
FROM Departments d
JOIN Locations l ON d.location_id = l.location_id
LEFT JOIN Employees e
ON d.department_id = e.department_id
AND e.commission_pct < 0.15;

/*7) Retrieve all employee details along with their department information but only for departments located in location ID 2500.*/
SELECT *
FROM Employees e
JOIN Departments d
ON e.department_id = d.department_id
WHERE d.location_id = 2500;

/*8) Show all departments in location ID 1900 that currently have no employees assigned to them.*/
SELECT *
FROM Departments d
WHERE d.location_id = 1900
AND NOT EXISTS (
    SELECT 1 FROM Employees e
    WHERE e.department_id = d.department_id
);

/*9) List all employee pairs where one employee is the manager of the other, but only include those managers who were hired after 01-JAN-2000.*/
SELECT e1.first_name, e2.first_name
FROM Employees e1, Employees e2
WHERE e1.employee_id = e2.manager_id
AND e1.hire_date > '01-JAN-2000';

/*10) Display the names of employees along with their department names for those assigned to department 110.*/
SELECT e.first_name, d.department_name
FROM Employees e
JOIN Departments d
ON e.department_id = d.department_id
WHERE e.department_id = 110;

/*11) Display all employees and departments but only include employees whose commission percentage is null or departments located in location ID 2100.*/
SELECT *
FROM Employees e
FULL OUTER JOIN Departments d
ON e.department_id = d.department_id
WHERE e.commission_pct IS NULL
OR d.location_id = 2100;

/*12) Display department names, the city they are located in and the employees working there. Only display employees whose salary is between 8000 and 12000.*/
SELECT d.department_name, l.city, e.first_name
FROM Departments d
JOIN Locations l ON d.location_id = l.location_id
JOIN Employees e ON d.department_id = e.department_id
WHERE e.salary BETWEEN 8000 AND 12000;

/*13) Write a query to display all employee IDs from the employees table and all department IDs from the departments table in a single list without removing duplicates.*/ 
SELECT employee_id FROM Employees
UNION ALL
SELECT department_id FROM Departments;

/*14) Create a view called Employee_Departments that shows each employee’s first_name, last_name, and department_name by joining the Employees and Departments tables. 
Using the view Employee_Departments, write a query to display all employees who work in the “HR” department*/
CREATE VIEW Employee_Departments AS
SELECT e.first_name, e.last_name, d.department_name
FROM Employees e
JOIN Departments d ON e.department_id = d.department_id;

SELECT *
FROM Employee_Departments
WHERE department_name = 'HR';

/*15) Using an inline view, list the employee_id and first_name of employees whose first name starts with ‘A’*/
SELECT *
FROM (
    SELECT employee_id, first_name
    FROM Employees
    WHERE first_name LIKE 'A%'
);

-- Lab 6 - END
