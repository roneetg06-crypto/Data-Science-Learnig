/*
Title: Week 2 Day 3
Topic: Product Analysis
Database: PostgreSQL
*/

-- Question 1
-- Most Expensive Products
SELECT product_id,
       product_name,
       brand,
       price
FROM products
ORDER BY price DESC
LIMIT 5;

-- Question 2
-- Cheapest Product Per Category
WITH ranked_products AS (
    SELECT p.product_id,
           p.product_name,
           c.category_name,
           p.price,
           RANK() OVER (
               PARTITION BY c.category_id
               ORDER BY p.price ASC
           ) AS price_rank
    FROM products p
    INNER JOIN categories c
        ON p.category_id = c.category_id
)
SELECT product_id,
       product_name,
       category_name,
       price
FROM ranked_products
WHERE price_rank = 1;

-- Question 3
-- Products Never Ordered
SELECT p.product_id,
       p.product_name,
       p.brand
FROM products p
LEFT JOIN order_details od
    ON p.product_id = od.product_id
WHERE od.product_id IS NULL;

-- Question 4
-- Quantity Sold Per Product
SELECT p.product_name,
       COALESCE(SUM(od.quantity), 0) AS total_quantity_sold
FROM products p
LEFT JOIN order_details od
    ON p.product_id = od.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC;

-- Question 5
-- Revenue Per Product
SELECT p.product_name,
       COALESCE(SUM(od.quantity * od.unit_price * (1 - od.discount_percent / 100)), 0) AS revenue
FROM products p
LEFT JOIN order_details od
    ON p.product_id = od.product_id
GROUP BY p.product_name
ORDER BY revenue DESC;

-- Question 6
-- Top Revenue Product Per Category
WITH product_revenue AS (
    SELECT c.category_name,
           p.product_name,
           SUM(od.quantity * od.unit_price * (1 - od.discount_percent / 100)) AS revenue
    FROM categories c
    INNER JOIN products p
        ON c.category_id = p.category_id
    INNER JOIN order_details od
        ON p.product_id = od.product_id
    GROUP BY c.category_name,
             p.product_name
),
ranked_revenue AS (
    SELECT *,
           RANK() OVER (
               PARTITION BY category_name
               ORDER BY revenue DESC
           ) AS revenue_rank
    FROM product_revenue
)
SELECT category_name,
       product_name,
       revenue
FROM ranked_revenue
WHERE revenue_rank = 1;

-- Question 7
-- Category With Highest Average Price
SELECT c.category_name,
       AVG(p.price) AS average_price
FROM categories c
INNER JOIN products p
    ON c.category_id = p.category_id
GROUP BY c.category_name
ORDER BY average_price DESC
LIMIT 1;

