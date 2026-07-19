-- ===================================================
-- Week 2 - Day 4
-- Topic: CTEs & Advanced Business Analytics
-- Database: Amazon Sales Analytics
-- ===================================================

-- ===================================================
-- Question 1
-- Find customers whose total spending is greater than the average spending of all customers.
-- ===================================================
-- Original Query (kept for learning):
-- SELECT
--     c.customer_name
-- FROM customers AS c
-- JOIN orders AS o
--     ON c.customer_id = o.customer_id
-- JOIN order_details AS od
--     ON o.order_id = od.order_id
-- JOIN products AS p
--     ON od.product_id = p.product_id
-- GROUP BY
--     c.customer_id,
--     c.customer_name
-- HAVING SUM(p.price * od.quantity) > (
--     SELECT
--         AVG(p.price * od.quantity)
--     FROM customers AS c
--     JOIN orders AS o
--         ON c.customer_id = o.customer_id
--     JOIN order_details AS od
--         ON o.order_id = od.order_id
--     JOIN products AS p
--         ON od.product_id = p.product_id
-- );
--
-- Learning Note:
-- Initial approach compared total customer spending with average order-line revenue.
-- The business requirement asks for total customer spending greater than average customer spending.
-- The dataset also stores customer names as first_name and last_name, not customer_name.
-- Therefore the query has been corrected using customer-level CTEs and transaction net revenue.

WITH customer_spending AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(od.quantity * od.unit_price * (1 - od.discount_percent / 100)) AS total_spending
    FROM customers AS c
    JOIN orders AS o
        ON c.customer_id = o.customer_id
    JOIN order_details AS od
        ON o.order_id = od.order_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name
),
average_customer_spending AS (
    SELECT
        AVG(total_spending) AS average_spending
    FROM customer_spending
)
SELECT
    cs.customer_name,
    cs.total_spending
FROM customer_spending AS cs
CROSS JOIN average_customer_spending AS acs
WHERE cs.total_spending > acs.average_spending
ORDER BY
    cs.total_spending DESC;

-- Correction Explanation:
-- The comparison now uses each customer's total spending against the average of customer totals,
-- which matches the business question.

------------------------------------------------------

-- ===================================================
-- Question 2
-- Find the highest revenue product in each category.
-- ===================================================
-- Original Query (kept for learning):
-- WITH cte AS (
--     SELECT
--         c.category_name,
--         p.product_name,
--         SUM(p.price * od.quantity) AS revenue,
--         DENSE_RANK() OVER (
--             PARTITION BY c.category_name
--             ORDER BY SUM(p.price * od.quantity) DESC
--         ) AS rankers
--     FROM order_details AS od
--     JOIN products AS p
--         ON od.product_id = p.product_id
--     JOIN categories AS c
--         ON p.category_id = c.category_id
--     GROUP BY
--         c.category_name,
--         p.product_name
-- )
-- SELECT
--     category_name,
--     product_name,
--     revenue
-- FROM cte
-- WHERE rankers = 1
-- ORDER BY revenue DESC;
--
-- Learning Note:
-- The ranking logic was correct, but revenue was calculated from the current product price.
-- Sales analytics should use the transaction price and discount stored in order_details.

WITH product_revenue AS (
    SELECT
        c.category_name,
        p.product_id,
        p.product_name,
        SUM(od.quantity * od.unit_price * (1 - od.discount_percent / 100)) AS revenue
    FROM order_details AS od
    JOIN products AS p
        ON od.product_id = p.product_id
    JOIN categories AS c
        ON p.category_id = c.category_id
    GROUP BY
        c.category_name,
        p.product_id,
        p.product_name
),
ranked_products AS (
    SELECT
        pr.category_name,
        pr.product_name,
        pr.revenue,
        DENSE_RANK() OVER (
            PARTITION BY pr.category_name
            ORDER BY pr.revenue DESC
        ) AS revenue_rank
    FROM product_revenue AS pr
)
SELECT
    rp.category_name,
    rp.product_name,
    rp.revenue
FROM ranked_products AS rp
WHERE rp.revenue_rank = 1
ORDER BY
    rp.revenue DESC;

-- Correction Explanation:
-- Product revenue now reflects the actual sold unit price after discount, not the product list price.

------------------------------------------------------

-- ===================================================
-- Question 3
-- Find customers who purchased from every product category.
-- ===================================================
-- Original Query (kept for learning):
-- SELECT
--     cu.customer_name
-- FROM customers AS cu
-- JOIN orders AS o
--     ON cu.customer_id = o.customer_id
-- JOIN order_details AS od
--     ON o.order_id = od.order_id
-- JOIN products AS p
--     ON od.product_id = p.product_id
-- JOIN categories AS c
--     ON p.category_id = c.category_id
-- GROUP BY
--     cu.customer_name
-- HAVING COUNT(DISTINCT c.category_id) >= (
--     SELECT COUNT(*)
--     FROM categories
-- );
--
-- Learning Note:
-- The business logic was correct, but customer_name is not a column in the customers table.
-- Grouping by customer_id also prevents different customers with the same full name from being merged.

SELECT
    CONCAT(cu.first_name, ' ', cu.last_name) AS customer_name
FROM customers AS cu
JOIN orders AS o
    ON cu.customer_id = o.customer_id
JOIN order_details AS od
    ON o.order_id = od.order_id
JOIN products AS p
    ON od.product_id = p.product_id
JOIN categories AS c
    ON p.category_id = c.category_id
GROUP BY
    cu.customer_id,
    cu.first_name,
    cu.last_name
HAVING COUNT(DISTINCT c.category_id) = (
    SELECT
        COUNT(*)
    FROM categories
);

-- Correction Explanation:
-- The query now uses the real name columns and groups by customer_id for accurate customer-level results.

------------------------------------------------------

-- ===================================================
-- Question 4
-- Find categories whose total revenue is greater than the average category revenue.
-- ===================================================
-- Original Query (kept for learning):
-- SELECT
--     c.category_name,
--     ROUND(AVG(p.price * od.quantity), 2) AS revenue
-- FROM order_details AS od
-- JOIN products AS p
--     ON p.product_id = od.product_id
-- JOIN categories AS c
--     ON c.category_id = p.category_id
-- GROUP BY
--     category_name
-- HAVING SUM(p.price * od.quantity) > (
--     SELECT
--         AVG(p.price * od.quantity)
--     FROM order_details AS od
--     JOIN products AS p
--         ON p.product_id = od.product_id
-- );
--
-- Learning Note:
-- Initial approach displayed average line revenue but filtered using total category revenue.
-- The business question asks for categories with total revenue above average category revenue.
-- Therefore the query has been corrected using category totals in a CTE.

WITH category_revenue AS (
    SELECT
        c.category_id,
        c.category_name,
        SUM(od.quantity * od.unit_price * (1 - od.discount_percent / 100)) AS total_revenue
    FROM order_details AS od
    JOIN products AS p
        ON od.product_id = p.product_id
    JOIN categories AS c
        ON p.category_id = c.category_id
    GROUP BY
        c.category_id,
        c.category_name
),
average_category_revenue AS (
    SELECT
        AVG(total_revenue) AS average_revenue
    FROM category_revenue
)
SELECT
    cr.category_name,
    ROUND(cr.total_revenue, 2) AS total_revenue
FROM category_revenue AS cr
CROSS JOIN average_category_revenue AS acr
WHERE cr.total_revenue > acr.average_revenue
ORDER BY
    cr.total_revenue DESC;

-- Correction Explanation:
-- The query now compares category totals with the average of category totals, which is the correct business grain.

------------------------------------------------------

-- ===================================================
-- Question 5
-- Find products contributing more than 20% of total revenue.
-- ===================================================
-- Original Query (kept for learning):
-- WITH product_revenue AS (
--     SELECT
--         p.product_name,
--         SUM(p.price * od.quantity) AS revenue
--     FROM products AS p
--     JOIN order_details AS od
--         ON p.product_id = od.product_id
--     GROUP BY
--         p.product_name
-- )
-- SELECT
--     product_name,
--     revenue,
--     ROUND(
--         (revenue * 100.0) / (SELECT SUM(revenue) FROM product_revenue),
--         2
--     ) AS contribution_percentage
-- FROM product_revenue
-- WHERE revenue > (
--     SELECT SUM(revenue) * 0.20
--     FROM product_revenue
-- );
--
-- Learning Note:
-- The original solution correctly used product-level contribution.
-- Revenue has been corrected to use transaction price after discount and product_id has been added to grouping.

WITH product_revenue AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(od.quantity * od.unit_price * (1 - od.discount_percent / 100)) AS revenue
    FROM products AS p
    JOIN order_details AS od
        ON p.product_id = od.product_id
    GROUP BY
        p.product_id,
        p.product_name
),
total_revenue AS (
    SELECT
        SUM(revenue) AS revenue
    FROM product_revenue
)
SELECT
    pr.product_name,
    pr.revenue,
    ROUND((pr.revenue * 100.0) / tr.revenue, 2) AS contribution_percentage
FROM product_revenue AS pr
CROSS JOIN total_revenue AS tr
WHERE pr.revenue > tr.revenue * 0.20
ORDER BY
    pr.revenue DESC;

-- Correction Explanation:
-- Contribution is now calculated from actual net product revenue and compared against total net revenue.

------------------------------------------------------

-- ===================================================
-- Question 6
-- Find the top customer in each city by total spending.
-- ===================================================
-- Original Query (kept for learning):
-- WITH cte AS (
--     SELECT
--         c.city,
--         c.customer_name,
--         SUM(p.price * od.quantity) AS total_spending,
--         DENSE_RANK() OVER (
--             PARTITION BY c.city
--             ORDER BY SUM(p.price * od.quantity) DESC
--         ) AS rankers
--     FROM customers AS c
--     JOIN orders AS o
--         ON c.customer_id = o.customer_id
--     JOIN order_details AS od
--         ON o.order_id = od.order_id
--     JOIN products AS p
--         ON od.product_id = p.product_id
--     GROUP BY
--         c.city,
--         c.customer_name
-- )
-- SELECT
--     city,
--     customer_name,
--     total_spending
-- FROM cte
-- WHERE rankers = 1
-- ORDER BY total_spending DESC;
--
-- Learning Note:
-- The ranking idea was correct, but customer_name is not a table column.
-- Spending also needs to be calculated from order_details transaction values.

WITH customer_city_spending AS (
    SELECT
        c.city,
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(od.quantity * od.unit_price * (1 - od.discount_percent / 100)) AS total_spending
    FROM customers AS c
    JOIN orders AS o
        ON c.customer_id = o.customer_id
    JOIN order_details AS od
        ON o.order_id = od.order_id
    GROUP BY
        c.city,
        c.customer_id,
        c.first_name,
        c.last_name
),
ranked_city_customers AS (
    SELECT
        ccs.city,
        ccs.customer_name,
        ccs.total_spending,
        DENSE_RANK() OVER (
            PARTITION BY ccs.city
            ORDER BY ccs.total_spending DESC
        ) AS spending_rank
    FROM customer_city_spending AS ccs
)
SELECT
    rcc.city,
    rcc.customer_name,
    rcc.total_spending
FROM ranked_city_customers AS rcc
WHERE rcc.spending_rank = 1
ORDER BY
    rcc.total_spending DESC;

-- Correction Explanation:
-- The query now ranks real customer records within each city using net transaction spending.

------------------------------------------------------

-- ===================================================
-- Question 7
-- Challenge: Rank customers by order count, quantity purchased, and total spending.
-- ===================================================
-- Original Query (kept for learning):
-- SELECT
--     cu.customer_name,
--     cu.city,
--     COUNT(DISTINCT o.order_id) AS total_order,
--     SUM(od.quantity) AS total_quantity,
--     SUM(od.quantity * p.price) AS total_spending,
--     DENSE_RANK() OVER (
--         ORDER BY SUM(od.quantity * p.price) DESC
--     ) AS rankers
-- FROM customers AS cu
-- JOIN orders AS o
--     ON cu.customer_id = o.customer_id
-- JOIN order_details AS od
--     ON o.order_id = od.order_id
-- JOIN products AS p
--     ON od.product_id = p.product_id
-- JOIN categories AS c
--     ON p.category_id = c.category_id
-- GROUP BY
--     cu.customer_name,
--     cu.city;
--
-- Learning Note:
-- The original query included the right customer analytics measures, but customer_name does not exist.
-- It also joined categories even though no category field was selected or filtered.
-- Total spending has been corrected to use transaction price after discount.

WITH customer_summary AS (
    SELECT
        cu.customer_id,
        CONCAT(cu.first_name, ' ', cu.last_name) AS customer_name,
        cu.city,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(od.quantity) AS total_quantity,
        SUM(od.quantity * od.unit_price * (1 - od.discount_percent / 100)) AS total_spending
    FROM customers AS cu
    JOIN orders AS o
        ON cu.customer_id = o.customer_id
    JOIN order_details AS od
        ON o.order_id = od.order_id
    GROUP BY
        cu.customer_id,
        cu.first_name,
        cu.last_name,
        cu.city
)
SELECT
    cs.customer_name,
    cs.city,
    cs.total_orders,
    cs.total_quantity,
    cs.total_spending,
    DENSE_RANK() OVER (
        ORDER BY cs.total_spending DESC
    ) AS spending_rank
FROM customer_summary AS cs
ORDER BY
    spending_rank,
    cs.customer_name;

-- Correction Explanation:
-- The query now returns valid customer names, removes an unused join, and ranks customers by actual net spending.

------------------------------------------------------

-- ===================================================
-- Question 8
-- Explore the full order-level sales dataset with customer, product, and category details.
-- ===================================================
-- Original Query (kept for learning):
-- SELECT *
-- FROM customers AS cu
-- JOIN orders AS o
--     ON cu.customer_id = o.customer_id
-- JOIN order_details AS od
--     ON o.order_id = od.order_id
-- JOIN products AS p
--     ON od.product_id = p.product_id
-- JOIN categories AS c
--     ON p.category_id = c.category_id;
--
-- Learning Note:
-- SELECT * is useful while exploring, but an interview-ready query should list the business fields
-- explicitly so the output is stable and easy to understand.

SELECT
    cu.customer_id,
    CONCAT(cu.first_name, ' ', cu.last_name) AS customer_name,
    cu.city,
    cu.state,
    o.order_id,
    o.order_date,
    o.order_status,
    o.payment_method,
    p.product_id,
    p.product_name,
    c.category_name,
    od.quantity,
    od.unit_price,
    od.discount_percent,
    od.quantity * od.unit_price * (1 - od.discount_percent / 100) AS net_revenue
FROM customers AS cu
JOIN orders AS o
    ON cu.customer_id = o.customer_id
JOIN order_details AS od
    ON o.order_id = od.order_id
JOIN products AS p
    ON od.product_id = p.product_id
JOIN categories AS c
    ON p.category_id = c.category_id
ORDER BY
    o.order_date,
    o.order_id,
    p.product_name;

------------------------------------------------------

-- ===================================================
-- Question 9
-- Find the average product list price across all products.
-- ===================================================
-- Original Query (kept for learning):
-- SELECT
--     AVG(price)
-- FROM products;

SELECT
    ROUND(AVG(p.price), 2) AS average_product_price
FROM products AS p;

------------------------------------------------------

-- ===================================================
-- Question 10
-- Find the average product list price by category.
-- ===================================================
-- Original Query (kept for learning):
-- SELECT
--     category_id,
--     AVG(price)
-- FROM products
-- GROUP BY
--     category_id;
--
-- Learning Note:
-- The original query was logically valid, but category names make the result more readable for business users.

SELECT
    c.category_name,
    ROUND(AVG(p.price), 2) AS average_product_price
FROM products AS p
JOIN categories AS c
    ON p.category_id = c.category_id
GROUP BY
    c.category_id,
    c.category_name
ORDER BY
    average_product_price DESC;
