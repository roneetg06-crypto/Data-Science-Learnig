/*
Title: Week 2 Day 2
Topic: Business Analysis
Database: PostgreSQL
*/

-- Question 1
-- Customer Spending
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       SUM(od.quantity * od.unit_price * (1 - od.discount_percent / 100)) AS total_spending
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
INNER JOIN order_details od
    ON o.order_id = od.order_id
GROUP BY c.customer_id,
         c.first_name,
         c.last_name
ORDER BY total_spending DESC;

-- Question 2
-- City Wise Customers
SELECT city,
       state,
       COUNT(*) AS customer_count
FROM customers
GROUP BY city,
         state
ORDER BY customer_count DESC;

-- Question 3
-- Payment Method Analysis
SELECT payment_method,
       COUNT(*) AS total_orders
FROM orders
GROUP BY payment_method
ORDER BY total_orders DESC;

-- Question 4
-- Revenue By Category
SELECT c.category_name,
       SUM(od.quantity * od.unit_price * (1 - od.discount_percent / 100)) AS revenue
FROM categories c
INNER JOIN products p
    ON c.category_id = p.category_id
INNER JOIN order_details od
    ON p.product_id = od.product_id
GROUP BY c.category_name
ORDER BY revenue DESC;

-- Question 5
-- Top Selling Products
SELECT p.product_name,
       SUM(od.quantity) AS total_quantity_sold
FROM products p
INNER JOIN order_details od
    ON p.product_id = od.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC;

-- Question 6
-- Categories Purchased by Customer
SELECT cst.customer_id,
       cst.first_name,
       cst.last_name,
       cat.category_name
FROM customers cst
INNER JOIN orders o
    ON cst.customer_id = o.customer_id
INNER JOIN order_details od
    ON o.order_id = od.order_id
INNER JOIN products p
    ON od.product_id = p.product_id
INNER JOIN categories cat
    ON p.category_id = cat.category_id
GROUP BY cst.customer_id,
         cst.first_name,
         cst.last_name,
         cat.category_name
ORDER BY cst.customer_id;

-- Question 7
-- Customer Purchase Summary
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       COUNT(DISTINCT o.order_id) AS total_orders,
       SUM(od.quantity) AS total_items,
       SUM(od.quantity * od.unit_price * (1 - od.discount_percent / 100)) AS total_revenue
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
INNER JOIN order_details od
    ON o.order_id = od.order_id
GROUP BY c.customer_id,
         c.first_name,
         c.last_name
ORDER BY total_revenue DESC;

