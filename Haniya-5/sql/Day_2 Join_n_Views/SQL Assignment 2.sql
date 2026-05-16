-- Q1
-- Show all product names along with their brand name. Sort by brand name, then by product name alphabetically.
SELECT 
	p.product_name, 
	b.brand_name
FROM [production].[products] p
 
INNER JOIN [production].[brands] b
ON p.brand_id = b.brand_id
ORDER BY b.brand_name ASC, p.product_name ASC;

-- Q2
-- List all products with their category name and list price. Sort by category name, then by price from cheapest to most expensive.

SELECT
	p.list_price,
	c.category_name
From [production].[products] p
INNER JOIN [production].[categories] c
ON p.category_id = c.category_id
order by c.category_name ASC, p.list_price ASC;

-- Q3
-- Show all orders with the customer's full name and order date. Sort by order date from newest to oldest.

SELECT
	c.first_name + ' ' + c.last_name AS full_name,
	o.order_date
FROM [sales].[customers] c
INNER JOIN [sales].[orders] o
ON c.customer_id = o.customer_id
ORDER BY order_date DESC

-- Q4
-- Display each order item with the product name, quantity, unit price, and a computed column called "Line Total" (quantity × list_price). Sort by order ID.

SELECT 
	p.product_name,
	s.quantity,
	p.list_price,
	p.list_price * s.quantity as Line_total
FROM [production].[products] p
INNER JOIN [production].[stocks] s
ON p.product_id = s.product_id;

-- Q5
-- Show each order along with the store name where it was placed and the order date. Sort by store name.

SELECT 
	s.store_name,
	o.order_date
FROM  [sales].[orders] o
INNER JOIN [sales].[stores] s
on s.store_id = o.store_id
ORDER BY s.store_name  ASC;

-- Q6
-- Show each order with: order ID, customer full name, store name, and the staff member's full name who handled it.
select * from [sales].[stores] s
select * from[sales].[staffs] sf
select * from [sales].[orders] o
select * from[sales].[customers] c

SELECT 
	o.order_id,
	c.first_name+ ' ' + c.last_name AS customer_full_name,
	s.store_name,
	sf.first_name + ' ' + sf.last_name AS staff_full_nam

FROM [sales].[orders] o
INNER JOIN [sales].[customers] c
ON o.customer_id = c.customer_id
INNER JOIN [sales].[stores] s
ON o.store_id = s.store_id 
INNER JOIN [sales].[staffs] sf
ON o.staff_id = sf.staff_id

-- Q7
-- List all products from the brand "Trek" along with their category name and price. Sort by price descending. (Use JOIN — do NOT filter by brand_id directly.)

SELECT 
     p.product_name,
     c.category_name,
     p.list_price
FROM [production].[products] p
INNER JOIN [production].[brands] b
ON b.brand_id = p.brand_id
INNER JOIN [production].[categories] c
ON p.category_id = c.category_id

WHERE brand_name = 'Trek'
ORDER BY list_price DESC

--Q8
-- Find all customers from the state of "NY" who have placed at least one order. Show customer full name, city, and order date. (Use JOIN — do not use a subquery.)

SELECT 
	c.first_name+ ' ' + C.last_name as full_name,
	o.order_date,
	c.city
FROM [sales].[customers] c
INNER JOIN [sales].[orders] o
ON c.customer_id = o.customer_id
WHERE state = 'NY'

--Q9
-- Show all completed orders (order_status = 4) from the store "Rowlett Bikes". Display order ID, customer full name, and order date.

SELECT 
	o.order_id,
	c.first_name+ ' '+ c.last_name AS full_nmae,
	o.order_date
FROM [sales].[orders] o
INNER JOIN [sales].[customers] c
ON c.customer_id = o.customer_id
INNER JOIN [sales].[stores] s
ON o.store_id = s.store_id
WHERE order_status = 4 AND store_name = 'Rowlett Bikes'

-- Q10
-- List ALL customers and any orders they have placed. Include customers who have never placed an order (show NULL for order columns). Sort by customer ID.

SELECT
	c.customer_id,
	c.first_name + ' ' + c.last_name AS full_name,
	o.order_id,
	o.shipped_date
FROM [sales].[customers] c
LEFT JOIN [sales].[orders] o
ON c.customer_id = o.customer_id
ORDER BY customer_id ASC

-- Q11
-- Find all customers who have NEVER placed an order. Show their full name and email.

SELECT
	c.first_name + ' ' + c.last_name AS full_name,
	c.email,
	o.shipped_date
FROM [sales].[customers] c
LEFT JOIN [sales].[orders] o
ON c.customer_id = o.customer_id
WHERE c.customer_id = null

-- Q12
-- List all products and their stock quantity at every store. Include products that have NO stock record at all. Show product name, store ID, and quantity.

SELECT
	p.product_name,
	s.store_id,
	s.quantity
FROM [production].[products] p
LEFT JOIN [production].[stocks]s
ON s.product_id = p.product_id

-- Q13
-- Find all products that have NEVER been ordered (no record in order_items). Show product name and list price.

SELECT 
	p.product_name,
	p.list_price

FROM [production].[products]p
LEFT JOIN [sales].[order_items] oi
ON p.product_id = oi.product_id
WHERE oi.order_id = null

-- Q14
-- List each staff member along with the full name of their manager. Staff with no manager (top-level) should still appear — show NULL for manager name.

SELECT
	s.staff_id,
	s.first_name + ' ' + s.last_name AS staff_full_name,
	m.staff_id,
	m.first_name + ' ' + m.last_name AS manager_full_name
FROM [sales].[staffs] s
LEFT JOIN [sales].[staffs] m
ON s.manager_id = m.manager_id


-- Q15
-- Create a view called vw_bike_catalog that shows product_name, brand_name, category_name, model_year, and list_price. Then query it to show only products priced over $2,000, sorted by price descending.

CREATE VIEW vw_bike_catalog AS
SELECT
	p.product_name,
	b.brand_name,
	c.category_name,
	p.model_year,
	p.list_price
FROM [production].[products] p
INNER JOIN [production].[brands] b
ON p.brand_id = b.brand_id
INNER JOIN [production].[categories] c
ON p.category_id = c.category_id

-- Q16
-- BONUS: Create a view called vw_customer_orders showing: customer full name, order_id, order_date, store_name, and order_status. 
--Then query it to show only orders where the customer city is "New York", sorted by order_date.
select *from [sales].[customers]c
select *from[sales].[orders]o
select *from[sales].[stores]s

ALTER VIEW w_customer_orders AS
SELECT
    c.first_name + ' ' + c.last_name AS full_name,
    o.order_id,
    o.order_date,
    s.store_name,
    o.order_status
FROM sales.customers c
INNER JOIN sales.orders o
    ON c.customer_id = o.customer_id
INNER JOIN sales.stores s
    ON o.store_id = s.store_id
WHERE s.city = 'NY';