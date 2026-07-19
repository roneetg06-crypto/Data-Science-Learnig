select * from customers;
select * from orders;
select * from order_details;
select * from products;
select * from categories;

-- 📋 Task 1 – Executive Sales Summary
SELECT 
	COUNT(DISTINCT c.customer_id) AS total_customer,
	COUNT(DISTINCT o.order_id) AS total_order,
	COUNT(DISTINCT p.product_id) AS total_products,
	ROUND(SUM(p.price*od.quantity),2) AS total_revenue,
	ROUND(SUM(p.price*od.quantity)
			/(SELECT COUNT(DISTINCT order_id)
			FROM orders),2) AS average_order_revenue
FROM customers AS c
JOIN orders AS o
	ON c.customer_id = o.customer_id
JOIN order_details AS od
	ON o.order_id = od.order_id
JOIN products AS p
	ON od.product_id = p.product_id;

-- 📋 Task 2 – Customer Performance Report

WITH customer_dashboard as 
(
	SELECT 
		c.customer_name,
		COUNT(o.order_id) AS total_order,
		SUM(od.quantity) AS total_qunatity,
		SUM(p.price*od.quantity) AS total_spending
	FROM customers AS c
	JOIN orders AS o
		ON c.customer_id = o.customer_id
	JOIN order_details as od
		ON o.order_id = od.order_id
	JOIN products AS p
		ON od.product_id = p.product_id
	GROUP BY c.customer_id,
			c.customer_name
)


SELECT 
	*,
	DENSE_RANK()
	OVER(
		ORDER BY total_spending DESC
	) AS customer_rank,
	NTILE(4)
	OVER(
		ORDER BY total_spending DESC
	) AS quartile
FROM customer_dashboard;

-- 📋 Task 3 – Product Performance Report
WITH product_dashboard AS 
(
	SELECT 
		p.product_name,
		c.category_name,
		SUM(od.quantity) AS quantity_sold,
		SUM(p.price*od.quantity) AS revenue
	FROM order_details as od 
	JOIN products as p
		ON od.product_id = p.product_id
	JOIN categories as c
		ON p.category_id = c.category_id
	GROUP BY p.product_name,
			c.category_name
)
SELECT 
	*,
		DENSE_RANK()
	OVER(
		ORDER BY revenue DESC
	) AS revenue_rank
FROM product_dashboard;

-- 📋 Task 4 – Category Performance Report

SELECT 
	c.category_name,
	COUNT(DISTINCT p.product_id) AS count_product,
	SUM(p.price*od.quantity) AS revenue,
	ROUND(AVG(p.price*od.quantity),2) AS avg_product_price
FROM order_details AS od
JOIN products As p
	ON od.product_id = p.product_id
JOIN categories AS c
	ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY revenue DESC;

-- 📋 Task 5 – City Performance Report
SELECT 
	c.city,
	COUNT(DISTINCT c.customer_id) AS customer_count,
	COUNT(DISTINCT o.order_id) AS total_orders,
	SUM(p.price*od.quantity) AS revenue
FROM customers AS c
JOIN orders AS o
	ON c.customer_id = o.customer_id
JOIN order_details AS od
	ON o.order_id = od.order_id
JOIN products as p
	ON od.product_id = p.product_id
GROUP BY c.city
ORDER BY revenue DESC;

-- 📋 Task 6 – Business Insights Queries

-- Top 5 customers by revenue.
WITH top_5 AS
(
	SELECT 
		c.customer_name,
		SUM(p.price*od.quantity) AS revenue,
		DENSE_RANK()
		OVER
		(
			ORDER BY SUM(p.price*od.quantity) DESC
		) AS top_5_customer
	FROM customers AS c
	JOIN orders AS o
		ON c.customer_id = o.customer_id
	JOIN order_details AS od
		ON o.order_id = od.order_id
	JOIN products AS p
	 	ON od.product_id = p.product_id
	GROUP BY c.customer_id,
			c.customer_name
)
SELECT
	*
FROM top_5
WHERE top_5_customer BETWEEN 1 AND 5;

-- Bottom 5 customers by revenue.
WITH bottom_5 AS
(
	SELECT 
		c.customer_name,
		SUM(p.price*od.quantity) AS revenue,
		DENSE_RANK()
		OVER
		(
			ORDER BY SUM(p.price*od.quantity) 
		) AS bottom_5_customer
	FROM customers AS c
	JOIN orders AS o
		ON c.customer_id = o.customer_id
	JOIN order_details AS od
		ON o.order_id = od.order_id
	JOIN products AS p
	 	ON od.product_id = p.product_id
	GROUP BY c.customer_id,
			c.customer_name
)
SELECT
	*
FROM bottom_5
WHERE bottom_5_customer BETWEEN 1 AND 5;

-- Most popular payment method.
WITH popular_payment_method AS
(
	SELECT
		payment_method,
		COUNT(DISTINCT o.order_id) AS most_popular,
		DENSE_RANK()
		OVER(
			ORDER BY COUNT(customer_id) DESC 
		) top_prd
	FROM orders
	GROUP BY payment_method
)
SELECT 
	payment_method
FROM popular_payment_method
WHERE top_prd = 1;
-- Most expensive product sold.

SELECT 
	product_name
FROM products 
ORDER BY price DESC
LIMIT 1;

-- Category contributing the highest revenue.
SELECT 
	c.category_name
FROM order_details AS od
JOIN products AS p
	ON od.product_id = p.product_id
JOIN categories AS c
	ON p.category_id = c.category_id
group by c.category_name
ORDER BY SUM(p.price*od.quantity) DESC
LIMIT 1;

-- Customers with no orders.
SELECT 
	c.customer_name
FROM customers AS c
LEFT JOIN orders AS o
	ON c.customer_id = o.customer_id
WHERE order_id IS NULL;



-- 🌟 Final Challenge (Interview Level)
WITH dashboard AS
(
	SELECT 
		c.customer_name,
		c.city,
		SUM(od.quantity) AS total_quantity,
		COUNT(DISTINCT o.order_id) AS total_order,
		SUM(p.price*od.quantity) AS total_spending,
		DENSE_RANK()
		OVER
		(
			ORDER BY SUM(p.price*od.quantity) DESC
		)AS customer_rank,
		NTILE(4)
		OVER
		(
			ORDER BY SUM(p.price*od.quantity) DESC
		) AS quartile
	FROM customers AS c
	JOIN orders AS o
		ON c.customer_id = o.customer_id
	JOIN order_details AS od
		ON o.order_id = od.order_id
	JOIN products AS p
		ON od.product_id = p.product_id
	GROUP BY c.customer_id,
			c.customer_name,
			c.city
)
SELECT 
	*,
	CASE 
	WHEN quartile = 1 THEN 'PLATINUM'
	WHEN quartile = 2 THEN 'GOLD'
	WHEN quartile = 3 THEN 'SILVER'
	ELSE 'BRONZE'
	END AS customer_type
FROM dashboard;










	






















