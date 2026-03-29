/*CL2006 - DATABASE SYSTEMS - LAB 7 (PREDICTED) - BAI-4A - 24K-0017*/

-- Lab 7 - START

-- Q1) Use HR Schema (JOINS)
/*A. Display employee full name, department name, and city they work in.
B. Display employees along with their job title and salary using INNER JOIN.
C. Display all employees and their departments (include those without department).
D. Display all departments and employees (include departments with no employees).
E. Display employee name and their manager name using SELF JOIN.*/

-- a)
SELECT e.first_name || ' ' || e.last_name AS full_name,
       d.department_name,
       l.city
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id;

-- b)
SELECT e.first_name, j.job_title, e.salary
FROM employees e
INNER JOIN jobs j ON e.job_id = j.job_id;

-- c)
SELECT e.first_name, d.department_name
FROM employees e
LEFT OUTER JOIN departments d
ON e.department_id = d.department_id;

-- d)
SELECT e.first_name, d.department_name
FROM employees e
RIGHT OUTER JOIN departments d
ON e.department_id = d.department_id;

-- e)
SELECT e.first_name AS employee,
       m.first_name AS manager
FROM employees e
JOIN employees m
ON e.manager_id = m.employee_id;

-- Q2) Advanced JOINS + CONDITIONS

/*A. Display employees who work in the same city as their manager.
B. Display employees whose salary is greater than the average salary of their department.
C. Display employees working in departments located in 'Seattle'.
D. Display departments where no employee is assigned.
E. Display employees hired before their manager.*/

-- a)
SELECT e.first_name
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
JOIN departments d1 ON e.department_id = d1.department_id
JOIN departments d2 ON m.department_id = d2.department_id
WHERE d1.location_id = d2.location_id;

-- b)
SELECT *
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
);

-- c)
SELECT e.first_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
WHERE l.city = 'Seattle';

-- d)
SELECT *
FROM departments d
WHERE NOT EXISTS (
    SELECT 1 FROM employees e
    WHERE e.department_id = d.department_id
);

-- e)
SELECT e.first_name
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
WHERE e.hire_date < m.hire_date;

-- Q3) SET OPS
/*A. Display all employee IDs from employees and job_history (remove duplicates).
B. Display all employee IDs including duplicates.
C. Display employees who changed jobs.
D. Display employees who never changed jobs.*/

-- a)
SELECT employee_id FROM employees
UNION
SELECT employee_id FROM job_history;

-- b)
SELECT employee_id FROM employees
UNION ALL
SELECT employee_id FROM job_history;

-- c)
SELECT employee_id FROM employees
INTERSECT
SELECT employee_id FROM job_history;

-- d)
SELECT employee_id FROM employees
MINUS
SELECT employee_id FROM job_history;

-- Q4) VIEWS
/*A. Create a simple view showing employee name and salary.
B. Create a view showing employees earning more than 8000.
C. Create a complex view showing employee, department, and job title.
D. Create a read-only view for departments.
E. Modify an existing view to include last_name.*/

-- a)
CREATE OR REPLACE VIEW emp_view AS
SELECT first_name, salary
FROM employees;

-- b)
CREATE OR REPLACE VIEW high_salary_view AS
SELECT employee_id, first_name, salary
FROM employees
WHERE salary > 8000;

-- c)
CREATE OR REPLACE VIEW emp_full_view AS
SELECT e.first_name, d.department_name, j.job_title
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN jobs j ON e.job_id = j.job_id;

-- d)
CREATE OR REPLACE VIEW dept_view AS
SELECT department_id, department_name
FROM departments
WITH READ ONLY;

-- e)
CREATE OR REPLACE VIEW emp_view AS
SELECT first_name, last_name, salary
FROM employees;

-- Q5) MIXED (JOINS + SUBQUERY + VIEWS)
/*Display employees who:
- Work in departments where average salary > company average
- Earn more than their department average
- Exist in job_history
- Show their department name and job title*/

SELECT e.first_name, d.department_name, j.job_title
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN jobs j ON e.job_id = j.job_id
WHERE e.department_id IN (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    HAVING AVG(salary) > (SELECT AVG(salary) FROM employees)
)
AND e.salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
)
AND EXISTS (
    SELECT 1 FROM job_history jh
    WHERE jh.employee_id = e.employee_id
);

-- Q6) INLINE VIEW
/*Display employees whose salary is greater than average salary using inline view*/

SELECT *
FROM (
    SELECT employee_id, first_name, salary
    FROM employees
)
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Q7) 
/*Display employees who:
- Are not managers
- Work in departments with more than 3 employees
- Earn more than ALL employees in department 30
- Show employee name, department name, and city*/

SELECT e.first_name, d.department_name, l.city
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id
WHERE e.employee_id NOT IN (
    SELECT manager_id FROM employees WHERE manager_id IS NOT NULL
)
AND e.department_id IN (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    HAVING COUNT(*) > 3
)
AND e.salary > ALL (
    SELECT salary FROM employees WHERE department_id = 30
);

-- Lab 7 - END
