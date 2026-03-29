/*CL2006 - DATABASE SYSTEMS - LAB 4 - BAI-4A - 24K-0017*/

-- Lab 4 - START

-- Q1) Use HR Schema to: 
/*A. Display salary increased by 10% for all employees.
B. Display employees where salary > 5000 AND department_id = 50.
C. Display employees where salary BETWEEN 4000 AND 8000.
D. Display employees whose first_name starts with 'A'.
E. Display employees whose department_id IN (10,20,30).*/

-- a)
SELECT employee_id, first_name, salary, salary*1.10 AS increased_salary
FROM Employees;

-- b)
SELECT *
FROM Employees
WHERE salary > 5000
AND department_id = 50;

-- c)
SELECT *
FROM Employees
WHERE salary BETWEEN 4000 AND 8000;

-- d)
SELECT *
FROM Employees
WHERE first_name LIKE 'A%';

-- e)
SELECT *
FROM Employees
WHERE department_id IN (10,20,30);

-- Q2) Use HR Schema to:
/*Display employees whose first_name contains 'an'.
Display employees ordered by salary DESC
Display the first 5 employees using ROWNUM.
Display the next 5 employees using OFFSET.
Display full name using CONCAT or || operator.*/

-- a)
SELECT *
FROM Employees
WHERE first_name LIKE '%an%';

-- b)
SELECT *
FROM Employees
ORDER BY salary DESC;

-- c)
SELECT *
FROM Employees
WHERE ROWNUM <= 5;

-- d)
SELECT *
FROM Employees
ORDER BY employee_id OFFSET 5 ROWS
FETCH NEXT 5 ROWS ONLY;

-- e)
SELECT first_name || ' ' || last_name AS full_name
FROM Employees;

-- Q3) The HR department wants to standardize employee names:
/*All names in uppercase
Remove leading/trailing spaces
Write a query to display cleaned full names using UPPER() and TRIM()*/

SELECT 
UPPER(TRIM(first_name || ' ' || last_name)) AS cleaned_name
FROM employees;

-- Q4) Company migrated its emails:
/*Old format: @oldcompany.com
New format: @newcompany.comWrite a query to replace all old emails with the new domain using REPLACE()*/

SELECT
REPLACE(email,'@oldcompany.com','@newcompany.com') AS new_email
FROM Employees;

-- Q5) You need a report of employees:
/*Name contains 'an'
Hired between 2010 and 2015
Write a query using LIKE and BETWEEN*/

SELECT *
FROM Employees
WHERE first_name LIKE '%an%'
AND hire_date BETWEEN '01-JAN-2010' AND '31-DEC-2015';

-- Q6) Finance wants to display salaries:
/*Rounded to 2 decimals
Formatted with commas
Use ROUND() and TO_CHAR() to display salary as 12,345.67*/

SELECT
TO_CHAR(ROUND(salary,2),'99,999.99') AS formatted_salary
FROM Employees;

-- Lab 4 - END
