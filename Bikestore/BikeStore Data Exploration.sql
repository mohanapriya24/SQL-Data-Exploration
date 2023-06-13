use BikeStores;

--1. A list of all sales orders with staff id is 9.
SELECT * FROM sales.orders WHERE staff_id=9;

--2. All the customers who live in New York and provided a phone number.
SELECT first_name,last_name,phone FROM sales.customers WHERE city = 'New York' AND phone != 'NULL';
SELECT CONCAT(first_name,' ',last_name) as Customer_name,phone FROM sales.customers WHERE city = 'New York' AND phone != 'NULL';


--3. The names of the customers who ordered from Baldwin Bikes and Santa Cruz Bikes stores.
select DISTINCT (CONCAT(first_name,' ',last_name)) as Customer_name
FROM sales.customers
JOIN 
(
	SELECT order_id,customer_id,store_id
	FROM sales.orders
	WHERE store_id IN 
	(SELECT store_id FROM sales.stores WHERE store_name='Baldwin Bikes' OR store_name = 'Santa Cruz Bikes')
) AS orders 
ON sales.customers.customer_id=orders.customer_id;

--4. The name of the items_id whose discount is more than 5% (i.e 0.05).
SELECT item_id FROM sales.order_items WHERE discount > 0.05;

--5. Update Customer table with new column (i.e Name) by adding first_name and last_name.
ALTER TABLE sales.customers ADD Names VARCHAR (255);
UPDATE sales.customers SET Names =CONCAT(first_name,' ',last_name);
select * from sales.customers;

--6. All the customers name, phone number, address, city, state who ordered from store_id = 2.
SELECT DISTINCT Names, phone, street, city, state 
FROM sales.customers
JOIN
sales.orders
ON
sales.customers.customer_id=sales.orders.customer_id
WHERE 
store_id=2;

--7. All the staff names with discount > 0.05
SELECT CONCAT(first_name,' ',last_name) as Staff_name
FROM 
sales.staffs
where staff_id in 
(
SELECT staff_id FROM sales.orders 
WHERE order_id IN (SELECT order_id FROM sales.order_items WHERE discount>0.05)
);

SELECT DISTINCT(CONCAT(first_name,' ',last_name)) as Staff_name
FROM 
sales.staffs
LEFT JOIN sales.orders on sales.staffs.staff_id=sales.orders.staff_id
LEFT JOIN sales.order_items ON sales.order_items.order_id=sales.orders.order_id
WHERE
discount>0.05;


--8. All the customers who ordered the most expensive bike.
select DISTINCT(CONCAT(first_name,' ',last_name)) as Customer_name
FROM sales.customers 
JOIN sales.orders ON (sales.orders.customer_id=sales.customers.customer_id)
JOIN sales.order_items ON (sales.order_items.order_id=sales.orders.order_id)
WHERE 
list_price=(SELECT MAX(list_price) FROM sales.order_items);

--9. All the customers who ordered Mountain Bikes.
select DISTINCT(CONCAT(first_name,' ',last_name)) as Customer_name
FROM sales.customers 
LEFT JOIN sales.orders ON (sales.orders.customer_id=sales.customers.customer_id)
LEFT JOIN sales.order_items ON (sales.order_items.order_id=sales.orders.order_id)
LEFT JOIN production.products ON (production.products.product_id=sales.order_items.product_id)
LEFT JOIN production.categories ON (production.categories.category_id=production.products.category_id)
WHERE 
category_name='Mountain Bikes';

--10. The staff who sold highest number of bikes.
SELECT TOP 1(first_name),sum(quantity) num_of_bike
FROM sales.staffs 
LEFT JOIN sales.orders ON (sales.orders.staff_id=sales.staffs.staff_id)
LEFT JOIN sales.order_items ON (sales.order_items.order_id=sales.orders.order_id) group by first_name order by 2 desc;
