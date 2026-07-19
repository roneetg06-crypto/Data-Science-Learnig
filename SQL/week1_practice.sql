/*
Project Name   : Amazon Sales Analytics
Week Number    : Week 1
Database       : PostgreSQL
Topics Covered : Basic SELECT, WHERE, ORDER BY, LIMIT, Aggregates,
                 GROUP BY, HAVING, Joins, CTEs, Window Functions
*/

-- ============================================================
-- 1. Basic SELECT
-- ============================================================

-- Question 1
-- Display all employees
SELECT *
FROM employees;

-- Question 2
-- Display employee names and salaries
SELECT first_name,
       last_name,
       salary
FROM employees;

-- Question 3
-- Display all departments
SELECT *
FROM departments;

-- ============================================================
-- 2. WHERE
-- ============================================================

-- Question 1
-- Employees earning more than 50000
SELECT first_name,
       last_name,
       salary
FROM employees
WHERE salary > 50000;

-- Question 2
-- Employees from the Engineering department
SELECT first_name,
       last_name,
       department_id
FROM employees
WHERE department_id = 3;

-- Question 3
-- Employees hired after 2022-01-01
SELECT first_name,
       last_name,
       hire_date
FROM employees
WHERE hire_date > '2022-01-01';

-- ============================================================
-- 3. ORDER BY
-- ============================================================

-- Question 1
-- Employees ordered by salary from highest to lowest
SELECT first_name,
       last_name,
       salary
FROM employees
ORDER BY salary DESC;

-- Question 2
-- Employees ordered by hire date from oldest to newest
SELECT first_name,
       last_name,
       hire_date
FROM employees
ORDER BY hire_date ASC;

-- ============================================================
-- 4. LIMIT
-- ============================================================

-- Question 1
-- Top 5 highest paid employees
SELECT first_name,
       last_name,
       salary
FROM employees
ORDER BY salary DESC
LIMIT 5;

-- Question 2
-- First 3 departments
SELECT *
FROM departments
LIMIT 3;

-- ============================================================
-- 5. Aggregate Functions
-- ============================================================

-- Question 1
-- Count total employees
SELECT COUNT(*) AS total_employees
FROM employees;

-- Question 2
-- Find total salary expense
SELECT SUM(salary) AS total_salary_expense
FROM employees;

-- Question 3
-- Find average employee salary
SELECT AVG(salary) AS average_salary
FROM employees;

-- Question 4
-- Find minimum and maximum salary
SELECT MIN(salary) AS minimum_salary,
       MAX(salary) AS maximum_salary
FROM employees;

-- ============================================================
-- 6. GROUP BY
-- ============================================================

-- Question 1
-- Count employees in each department
SELECT department_id,
       COUNT(*) AS employee_count
FROM employees
GROUP BY department_id;

-- Question 2
-- Average salary by department
SELECT department_id,
       AVG(salary) AS average_salary
FROM employees
GROUP BY department_id;

-- ============================================================
-- 7. HAVING
-- ============================================================

-- Question 1
-- Departments with more than 2 employees
SELECT department_id,
       COUNT(*) AS employee_count
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 2;

-- Question 2
-- Departments with average salary above 70000
SELECT department_id,
       AVG(salary) AS average_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 70000;

-- ============================================================
-- 8. INNER JOIN
-- ============================================================

-- Question 1
-- Display employees with department names
SELECT e.first_name,
       e.last_name,
       d.department_name
FROM employees e
INNER JOIN departments d
    ON e.department_id = d.department_id;

-- ============================================================
-- 9. LEFT JOIN
-- ============================================================

-- Question 1
-- Display all departments with their employees
SELECT d.department_name,
       e.first_name,
       e.last_name
FROM departments d
LEFT JOIN employees e
    ON d.department_id = e.department_id;

-- ============================================================
-- 10. RIGHT JOIN
-- ============================================================

-- Question 1
-- Display all employees with department data using RIGHT JOIN
SELECT d.department_name,
       e.first_name,
       e.last_name
FROM departments d
RIGHT JOIN employees e
    ON d.department_id = e.department_id;

-- ============================================================
-- 11. SELF JOIN
-- ============================================================

-- Question 1
-- Display employees with their managers
SELECT e.first_name AS employee_first_name,
       e.last_name AS employee_last_name,
       m.first_name AS manager_first_name,
       m.last_name AS manager_last_name
FROM employees e
LEFT JOIN employees m
    ON e.manager_id = m.employee_id;

-- ============================================================
-- 12. CTE
-- ============================================================

-- Question 1
-- Find employees earning above the company average salary
WITH average_salary AS (
    SELECT AVG(salary) AS avg_salary
    FROM employees
)
SELECT first_name,
       last_name,
       salary
FROM employees
WHERE salary > (SELECT avg_salary FROM average_salary);

-- ============================================================
-- 13. WINDOW FUNCTIONS
-- ============================================================

-- Question 1
-- Rank employees by salary within each department
SELECT first_name,
       last_name,
       department_id,
       salary,
       RANK() OVER (
           PARTITION BY department_id
           ORDER BY salary DESC
       ) AS salary_rank
FROM employees;

-- Question 2
-- Calculate running salary total by hire date
SELECT first_name,
       last_name,
       hire_date,
       salary,
       SUM(salary) OVER (
           ORDER BY hire_date
       ) AS running_salary_total
FROM employees;

-- ============================================================
-- 14. INDUSTRY QUESTIONS
-- ============================================================

-- Question 1
-- Find the highest paid employee in each department
WITH ranked_employees AS (
    SELECT e.*,
           RANK() OVER (
               PARTITION BY department_id
               ORDER BY salary DESC
           ) AS salary_rank
    FROM employees e
)
SELECT first_name,
       last_name,
       department_id,
       salary
FROM ranked_employees
WHERE salary_rank = 1;

-- Question 2
-- Find department-wise salary cost
SELECT d.department_name,
       SUM(e.salary) AS total_salary_cost
FROM departments d
INNER JOIN employees e
    ON d.department_id = e.department_id
GROUP BY d.department_name
ORDER BY total_salary_cost DESC;

-- ============================================================
-- 15. HACKERRANK QUESTIONS
-- ============================================================

-- Question 1
-- Display employee names in alphabetical order
SELECT first_name,
       last_name
FROM employees
ORDER BY first_name ASC,
         last_name ASC;

-- Question 2
-- Display employees whose salary is between 50000 and 100000
SELECT first_name,
       last_name,
       salary
FROM employees
WHERE salary BETWEEN 50000 AND 100000;

