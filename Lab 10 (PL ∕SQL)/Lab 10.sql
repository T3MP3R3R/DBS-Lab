/*CL2005 - DATABASE SYSTEMS - LAB 10 - BAI-4A - 24K-0017*/

-- Lab 10 - START

-- Q1) Basic PL/SQL Blocks

/*Declare two variables, add them, and print the result*/

-- a)
DECLARE
    num1 NUMBER := 10;
    num2 NUMBER := 20;
    result NUMBER;
BEGIN
    result := num1 + num2;
    DBMS_OUTPUT.PUT_LINE('Sum = ' || result);
END;
/

/*Declare a string variable and print "Welcome to Database Lab"*/

-- b)
DECLARE
    msg VARCHAR2(50);
BEGIN
    msg := 'Welcome to Database Lab';
    DBMS_OUTPUT.PUT_LINE(msg);
END;
/

-- Q2) Control Structures and Queries

/*Check employee salary:
If salary > 50,000 → print "High Salary"
Else → print "Normal Salary"*/

-- a)
DECLARE
    salary NUMBER := 60000;
BEGIN
    IF salary > 50000 THEN
        DBMS_OUTPUT.PUT_LINE('High Salary');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Normal Salary');
    END IF;
END;
/

/*Fetch student name using SELECT INTO and display it*/

-- b)
DECLARE
    v_name EMPLOYEES.FIRST_NAME%TYPE;
BEGIN
    SELECT FIRST_NAME INTO v_name
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = 100;

    DBMS_OUTPUT.PUT_LINE('Student Name: ' || v_name);
END;
/

/*Bank system:
If balance < 1000 → add 500
Else → add 200*/

-- c)
DECLARE
    balance NUMBER := 800;
BEGIN
    IF balance < 1000 THEN
        balance := balance + 500;
    ELSE
        balance := balance + 200;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Updated Balance: ' || balance);
END;
/

/*Display all employees in department 90 using a FOR LOOP*/

-- d)
BEGIN
    FOR rec IN (
        SELECT FIRST_NAME, SALARY
        FROM EMPLOYEES
        WHERE DEPARTMENT_ID = 90
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Name: ' || rec.FIRST_NAME || ' Salary: ' || rec.SALARY);
    END LOOP;
END;
/

-- Q3) Decision Making

/*Payroll system:
If department = 10 → +1000 bonus
If department = 20 → +2000 bonus
Else → no change*/

-- a)
DECLARE
    dept NUMBER := 20;
    salary NUMBER := 5000;
BEGIN
    CASE
        WHEN dept = 10 THEN salary := salary + 1000;
        WHEN dept = 20 THEN salary := salary + 2000;
        ELSE salary := salary;
    END CASE;

    DBMS_OUTPUT.PUT_LINE('Updated Salary: ' || salary);
END;
/

/*Process salary:
If department = 90 AND salary is within range → apply commission*/

-- b)
DECLARE
    dept NUMBER := 90;
    salary NUMBER := 7000;
BEGIN
    IF dept = 90 THEN
        IF salary BETWEEN 5000 AND 10000 THEN
            salary := salary + (salary * 0.1);
        END IF;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Processed Salary: ' || salary);
END;
/

-- Q5) Procedure with IN, OUT, IN OUT parameters

/*Design a procedure:
Input: employee salary
OUT: bonus (10%)
IN OUT: updated salary after adding bonus*/

CREATE OR REPLACE PROCEDURE calc_bonus (
    p_salary     IN NUMBER,
    p_bonus      OUT NUMBER,
    p_new_salary IN OUT NUMBER
)
IS
BEGIN
    p_bonus := p_salary * 0.10;
    p_new_salary := p_salary + p_bonus;
END;
/

/*Execute the procedure and display results*/

DECLARE
    salary NUMBER := 10000;
    bonus NUMBER;
BEGIN
    calc_bonus(salary, bonus, salary);

    DBMS_OUTPUT.PUT_LINE('Bonus: ' || bonus);
    DBMS_OUTPUT.PUT_LINE('Updated Salary: ' || salary);
END;
/

-- Lab 10 - END
