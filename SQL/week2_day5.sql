select * from customers;
select * from orders;
select * from order_details;
select * from products;
select * from categories;

-- 📋 Task 1 – Rank Customers by Total Spending
select 
	dense_rank()
	over(
		order by sum(p.price*od.quantity) desc
	) as Rankers,
	cu.customer_name, 
	sum(p.price*od.quantity) as total_spending
from customers as cu
join orders as o
	on cu.customer_id = o.customer_id
join order_details as od
	on o.order_id = od.order_id
join products as p
	on od.product_id = p.product_id
GROUP BY
    cu.customer_id,
    cu.customer_name;

-- 📋 Task 2 – Top 2 Products in Each Category
with top_2_products as (
select
	c.category_name,
	p.product_name,
	sum(p.price*od.quantity) as revenue,
	dense_rank()
	over(
		partition by c.category_name
		order by sum(p.price*od.quantity) desc
	) as rankers
from order_details as od
join products as p
	on p.product_id = od.product_id
join categories as c
	on c.category_id = p.category_id
group by c.category_name,
	p.product_name
)
select 
	* 
from top_2_products 
where rankers between 1 and 2
order by revenue desc;


-- 📋 Task 3 – Running Revenue
with sales as (
select 
	o.order_date,
	sum(p.price*od.quantity) as revenue
from orders as o
join order_details as od
	on o.order_id = od.order_id
join products as p
	on p.product_id = od.product_id
group by o.order_date

)

select 
	*,
	sum(revenue)
	over(
		order by order_date
	) as running_rev
from sales;

-- 📋 Task 4 – Previous Order Revenue (LAG)


with prev_ord_rev as (
select 
	od.order_id,
	sum(p.price*od.quantity) as revenue
from order_details as od
join products as p
	on od.product_id = p.product_id
group by od.order_id

)

select *,
	lag(revenue)
	over(
		order by order_id
	) as previou_revenue
from prev_ord_rev;

-- 📋 Task 5 – Next Order Revenue (LEAD)
with prev_ord_rev as (
select 
	od.order_id,
	sum(p.price*od.quantity) as revenue
from order_details as od
join products as p
	on od.product_id = p.product_id
group by od.order_id

)

select *,
	lead(revenue)
	over(
		order by order_id
	) as previou_revenue
from prev_ord_rev;

-- 📋 Task 6 – Customer Spending Percentile (Challenge)
with spending_percentile as (
select 
	cu.customer_name,
	sum(p.price*od.quantity) as spending
from customers as cu
join orders as o
	on cu.customer_id = o.customer_id
join order_details as od
	on od.order_id = o.order_id
join products as p
	on p.product_id = od.product_id
group by cu.customer_id,
		cu.customer_name
)

select 
 	*,
	ntile(4)
	over(
		order by spending desc
	) as quartile
from spending_percentile
;


-- 🌟 Mini Dashboard Query
-- Create one report showing:
with report as (
	select 
		c.customer_name,
		c.city,
		count(distinct od.order_id) as total_order,
		sum(p.price*od.quantity) as spending
	from customers as c
	join orders as o
		on c.customer_id = o.customer_id
	join order_details as od
		on od.order_id = o.order_id
	join products as p
		on p.product_id = od.product_id
	group by c.customer_id,
			c.customer_name,
			c.city
)
select
	*,
	dense_rank()
	over(
		order by spending desc
	) as rankers,
	ntile(4)
	over()
	
from report;
	









