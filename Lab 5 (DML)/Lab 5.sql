/*CL2006 - DATABASE SYSTEMS - LAB 5 - BAI-4A - 24K-0017*/

-- Lab 5 - START

-- Q1) 
/*Display total number of employees.
Display maximum salary
Display minimum salary.
Display the total salary of all employees.
Display number of employees in each department.*/

SELECT COUNT(*) AS total_employees
FROM HR.Employees;

SELECT MAX(salary) AS max_salary
FROM HR.Employees;

SELECT MIN(salary) AS min_salary
FROM HR.Employees;

SELECT SUM(salary) AS total_salary
FROM HR.Employees;

SELECT department_id, COUNT(*) AS num_employees
FROM HR.Employees
GROUP BY department_id;

-- Q2) 
/*Display average salary per department.
Display departments having more than 5 employees.
Display department_id and total salary ordered by total salary DESC.
Insert a new department into the departments table.
Increase salary of department 50 employees by 5%*/

SELECT department_id, ROUND(AVG(salary), 2) AS avg_salary
FROM HR.Employees
GROUP BY department_id;

SELECT department_id, COUNT(*) AS num_employees
FROM HR.Employees
GROUP BY department_id
HAVING COUNT(*) > 5;

SELECT department_id, SUM(salary) AS total_salary
FROM HR.Employees
GROUP BY department_id
ORDER BY total_salary DESC;

INSERT INTO HR.DEPARTMENTS (department_id, department_name)
VALUES (280, 'Research');

SELECT employee_id, salary
FROM HR.Employees
WHERE department_id = 50;

-- Q3)
/*Display department_id, total salary, average salary
Only where average salary > 7000.
Delete department where department_id = 280.
Display departments where employees earning > 5000 are more than 3.
Insert into a new table using INSERT INTO SELECT from employees.
Write a query using WHERE, GROUP BY, HAVING, ORDER BY in one statement.*/

SELECT department_id,
COUNT(*) AS num_employees,
ROUND(SUM(salary), 2) AS total_salary,
ROUND(AVG(salary), 2) AS avg_salary
FROM HR.EMPLOYEES
WHERE salary > 5000
GROUP BY department_id
HAVING AVG(salary) > 7000
ORDER BY total_salary DESC; 

-- Lab 5 - END
