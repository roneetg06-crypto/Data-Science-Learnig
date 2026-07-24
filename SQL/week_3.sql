-- Total Sales
SELECT 
	SUM(totalamount)
FROM amazon_dataset;
-- Top Customers
SELECT 
	customername,
	SUM(totalamount) AS total_spending,
	DENSE_RANK()
	OVER(
		ORDER BY SUM(totalamount) DESC
	) customer_rank
FROM amazon_dataset
GROUP BY customerid, 
		customername
LIMIT 10;

-- Revenue by Category
SELECT 
	category,
	SUM(totalamount) AS revenue,
	DENSE_RANK()
	OVER(
		ORDER BY SUM(totalamount) DESC
	) AS category_rank
FROM amazon_dataset
GROUP BY category;


-- Average Order Value
SELECT 
	-- AVG(totalamount)
	ROUND(SUM(totalamount)/COUNT(DISTINCT orderid),2) AS avg_order_value
FROM amazon_dataset;

































