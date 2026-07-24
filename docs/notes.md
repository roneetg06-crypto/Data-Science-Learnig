# SQL Practice Workbook

**Project Name:** Amazon Sales Analytics  
**Database:** PostgreSQL  
**Focus:** Employee Management and SQL fundamentals  

---

## 1. Basic SELECT

Basic `SELECT` queries are used to retrieve data from one or more tables.  
This section focuses on displaying all columns and selecting specific columns from tables.  

```sql
-- Query 1: Display all employees
SELECT *
FROM employees;
```

```sql
-- Query 2: Display employee names and salaries
SELECT first_name,
       last_name,
       salary
FROM employees;
```

```sql
-- Query 3: Display all departments
SELECT *
FROM departments;
```

---

## 2. WHERE

The `WHERE` clause filters rows based on conditions.  
It is used to return only the records that match specific business rules.  

```sql
-- Query 1: Display employees earning more than 50000
SELECT first_name,
       last_name,
       salary
FROM employees
WHERE salary > 50000;
```

```sql
-- Query 2: Display employees from the Engineering department
SELECT first_name,
       last_name,
       department_id
FROM employees
WHERE department_id = 3;
```

```sql
-- Query 3: Display employees hired after 2022-01-01
SELECT first_name,
       last_name,
       hire_date
FROM employees
WHERE hire_date > '2022-01-01';
```

---

## 3. ORDER BY

The `ORDER BY` clause sorts query results in ascending or descending order.  
It is useful for ranking, reporting, and viewing records in a meaningful sequence.  

```sql
-- Query 1: Display employees ordered by salary from highest to lowest
SELECT first_name,
       last_name,
       salary
FROM employees
ORDER BY salary DESC;
```

```sql
-- Query 2: Display employees ordered by hire date from oldest to newest
SELECT first_name,
       last_name,
       hire_date
FROM employees
ORDER BY hire_date ASC;
```

---

## 4. LIMIT

The `LIMIT` clause restricts the number of rows returned by a query.  
It is commonly used to display top records, sample data, or short result sets.  

```sql
-- Query 1: Display the top 5 highest paid employees
SELECT first_name,
       last_name,
       salary
FROM employees
ORDER BY salary DESC
LIMIT 5;
```

```sql
-- Query 2: Display the first 3 departments
SELECT *
FROM departments
LIMIT 3;
```

---

## 5. Aggregate Functions

Aggregate functions summarize data across multiple rows.  
This section uses `COUNT`, `SUM`, `AVG`, `MIN`, and `MAX` for basic analysis.  

```sql
-- Query 1: Count total employees
SELECT COUNT(*) AS total_employees
FROM employees;
```

```sql
-- Query 2: Calculate total salary expense
SELECT SUM(salary) AS total_salary_expense
FROM employees;
```

```sql
-- Query 3: Calculate average employee salary
SELECT AVG(salary) AS average_salary
FROM employees;
```

```sql
-- Query 4: Find minimum and maximum salary
SELECT MIN(salary) AS minimum_salary,
       MAX(salary) AS maximum_salary
FROM employees;
```

---

## 6. GROUP BY

The `GROUP BY` clause groups rows that share common values.  
It is used with aggregate functions to create department-wise or category-wise summaries.  

```sql
-- Query 1: Count employees in each department
SELECT department_id,
       COUNT(*) AS employee_count
FROM employees
GROUP BY department_id;
```

```sql
-- Query 2: Calculate average salary by department
SELECT department_id,
       AVG(salary) AS average_salary
FROM employees
GROUP BY department_id;
```

---

## 7. HAVING

The `HAVING` clause filters grouped results after aggregation.  
It is used when conditions depend on aggregate values such as count or average.  

```sql
-- Query 1: Display departments with more than 2 employees
SELECT department_id,
       COUNT(*) AS employee_count
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 2;
```

```sql
-- Query 2: Display departments with average salary above 70000
SELECT department_id,
       AVG(salary) AS average_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 70000;
```

---

## 8. INNER JOIN

An `INNER JOIN` returns records that have matching values in both tables.  
It is useful for combining related data such as employees and departments.  

```sql
-- Query 1: Display employees with department names
SELECT e.first_name,
       e.last_name,
       d.department_name
FROM employees e
INNER JOIN departments d
    ON e.department_id = d.department_id;
```

---

## 9. LEFT JOIN

A `LEFT JOIN` returns all records from the left table and matching records from the right table.  
It is useful for finding records that may or may not have related data.  

```sql
-- Query 1: Display all departments with their employees
SELECT d.department_name,
       e.first_name,
       e.last_name
FROM departments d
LEFT JOIN employees e
    ON d.department_id = e.department_id;
```

---

## 10. RIGHT JOIN

A `RIGHT JOIN` returns all records from the right table and matching records from the left table.  
It is useful when the right-side table must be fully preserved in the result.  

```sql
-- Query 1: Display all employees with department data using RIGHT JOIN
SELECT d.department_name,
       e.first_name,
       e.last_name
FROM departments d
RIGHT JOIN employees e
    ON d.department_id = e.department_id;
```

---

## 11. SELF JOIN

A self join joins a table with itself.  
It is commonly used for hierarchy problems such as employees and managers.  

```sql
-- Query 1: Display employees with their managers
SELECT e.first_name AS employee_first_name,
       e.last_name AS employee_last_name,
       m.first_name AS manager_first_name,
       m.last_name AS manager_last_name
FROM employees e
LEFT JOIN employees m
    ON e.manager_id = m.employee_id;
```

---

## 12. CTE

A Common Table Expression, or CTE, creates a temporary named result set.  
CTEs make complex queries easier to read, maintain, and reuse.  

```sql
-- Query 1: Find employees earning above the company average salary
WITH average_salary AS (
    SELECT AVG(salary) AS avg_salary
    FROM employees
)
SELECT first_name,
       last_name,
       salary
FROM employees
WHERE salary > (SELECT avg_salary FROM average_salary);
```

---

## 13. Window Functions

Window functions perform calculations across related rows without collapsing the result.  
They are useful for ranking, running totals, and partition-based analysis.  

```sql
-- Query 1: Rank employees by salary within each department
SELECT first_name,
       last_name,
       department_id,
       salary,
       RANK() OVER (
           PARTITION BY department_id
           ORDER BY salary DESC
       ) AS salary_rank
FROM employees;
```

```sql
-- Query 2: Calculate running salary total by hire date
SELECT first_name,
       last_name,
       hire_date,
       salary,
       SUM(salary) OVER (
           ORDER BY hire_date
       ) AS running_salary_total
FROM employees;
```

---

## 14. Industry Problems

Industry-style SQL questions focus on practical reporting and analytics tasks.  
These queries answer business questions using joins, aggregates, CTEs, and ranking logic.  

```sql
-- Query 1: Find the highest paid employee in each department
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
```

```sql
-- Query 2: Find department-wise salary cost
SELECT d.department_name,
       SUM(e.salary) AS total_salary_cost
FROM departments d
INNER JOIN employees e
    ON d.department_id = e.department_id
GROUP BY d.department_name
ORDER BY total_salary_cost DESC;
```

---

## 15. HackerRank Practice

HackerRank-style SQL questions build problem-solving speed and accuracy.  
These examples focus on clean filtering, ordering, and readable query formatting.  

```sql
-- Query 1: Display employee names in alphabetical order
SELECT first_name,
       last_name
FROM employees
ORDER BY first_name ASC,
         last_name ASC;
```

```sql
-- Query 2: Display employees whose salary is between 50000 and 100000
SELECT first_name,
       last_name,
       salary
FROM employees
WHERE salary BETWEEN 50000 AND 100000;
```
