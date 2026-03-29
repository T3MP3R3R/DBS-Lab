/*CL2006 - DATABASE SYSTEMS - LAB 3 - BAI-4A - 24K-0017*/

-- Lab 3 - START

-- Q1) Create a table Course with course_id (Primary Key), course_name (NOT NULL), credit_hours (NUMBER)

CREATE TABLE Course (
    course_id NUMBER PRIMARY KEY,
    course_name VARCHAR2(50) NOT NULL,
    credit_hours NUMBER
);

-- Q2) Create a table Student with student_id (Primary Key), student_name (NOT NULL), age (CHECK age >= 18)

CREATE TABLE Student (
    student_id NUMBER PRIMARY KEY,
    student_name VARCHAR2(50) NOT NULL,
    age NUMBER CHECK (age >= 18)
);

-- Q3) USE STUDENT table with a column status having DEFAULT value 'Active'. Rename table Course to Courses.

ALTER TABLE Student
ADD status VARCHAR2(20) DEFAULT 'Active';

-- Q5) Create a Department table containing dept_id (Primary Key) and dept_name. Then create a Student table containing student_id (Primary Key), student_name, dept_id (Foreign Key referencing Department), and credit_hours.
-- After creating the tables, add a UNIQUE constraint on the email column in the Instructor table using ALTER, modify the student_name column to VARCHAR2(100), add a CHECK constraint so credit_hours must be between 1 and 4, and rename the column student_name to full_name.
   
CREATE TABLE Department (
    dept_id NUMBER PRIMARY KEY,
    dept_name VARCHAR2(50)
);

CREATE TABLE Student (
    student_id NUMBER PRIMARY KEY,
    student_name VARCHAR2(50),
    dept_id NUMBER,
    credit_hours NUMBER,
    CONSTRAINT student_dept
        FOREIGN KEY (dept_id)
        REFERENCES Department(dept_id)
);

ALTER TABLE Instructor
ADD CONSTRAINT instructor_email UNIQUE (email);

ALTER TABLE Student
MODIFY student_name VARCHAR2(100);

ALTER TABLE Student
ADD CONSTRAINT chk_credit_hours
CHECK (credit_hours BETWEEN 1 AND 4);

ALTER TABLE Student
RENAME COLUMN student_name TO full_name;

-- Q6) You are designing a Project Tracking System. Write the CREATE TABLE statement with all required constraints: Table Project with columns: project_id, project_name, start_date, end_date, budget. Budget must be greater than 10000. End_date must always be after start_date

CREATE TABLE Project (
    project_id NUMBER,
    project_name VARCHAR2(100) NOT NULL,
    start_date DATE,
    end_date DATE,
    budget NUMBER,
    CONSTRAINT pk_project PRIMARY KEY (project_id),
    CONSTRAINT chk_budget CHECK (budget > 10000),
    CONSTRAINT chk_dates CHECK (end_date > start_date)
);

-- Q7) A company tracks employees and departments. Table Employee references Department. You need to prevent assigning an employee to a non-existent department.
-- Write ALTER TABLE commands to enforce this foreign key. Also, explain what happens if someone tries to delete a department that still has employees.

ALTER TABLE Employee
ADD CONSTRAINT fk_employee_dept
FOREIGN KEY (dept_id)
REFERENCES Department(dept_id);

-- Q8) A startup company wants to create a table Product with the following: product_id (PK), product_name (unique, not null), price (check > 0), category_id (FK to Category table), status (default = 'Active')

CREATE TABLE Product (
    product_id NUMBER,
    product_name VARCHAR2(100) NOT NULL,
    price NUMBER,
    category_id NUMBER,
    status VARCHAR2(20) DEFAULT 'Active',
    
    CONSTRAINT pk_product PRIMARY KEY (product_id),
    CONSTRAINT uq_product_name UNIQUE (product_name),
    CONSTRAINT chk_price CHECK (price > 0),
    CONSTRAINT fk_product_category 
        FOREIGN KEY (category_id)
        REFERENCES Category(category_id)
);

-- Lab 3 - END
