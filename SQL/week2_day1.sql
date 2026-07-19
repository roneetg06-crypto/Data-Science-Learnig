/*
Title: Week 2 Day 1
Topic: Dataset Exploration
Database: PostgreSQL
*/

-- Question 1
-- Display Customers
SELECT *
FROM customers;

-- Question 2
-- Display Products
SELECT *
FROM products;

-- Question 3
-- Display Categories
SELECT *
FROM categories;

-- Question 4
-- Display Orders
SELECT *
FROM orders;

-- Question 5
-- Display Order Details
SELECT *
FROM order_details;

-- Question 6
-- Customer with Orders
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       o.order_id,
       o.order_date,
       o.order_status
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id;

-- Question 7
-- Product with Category
SELECT p.product_id,
       p.product_name,
       p.brand,
       p.price,
       c.category_name
FROM products p
INNER JOIN categories c
    ON p.category_id = c.category_id;

-- Question 8
-- Order Details Report
SELECT od.order_detail_id,
       o.order_id,
       o.order_date,
       p.product_name,
       od.quantity,
       od.unit_price,
       od.discount_percent
FROM order_details od
INNER JOIN orders o
    ON od.order_id = o.order_id
INNER JOIN products p
    ON od.product_id = p.product_id;

-- Question 9
-- Customer Order Count
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       COUNT(o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id,
         c.first_name,
         c.last_name;

-- Question 10
-- Customers Without Orders
SELECT c.customer_id,
       c.first_name,
       c.last_name
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

