create database sales;

use sales;

select * from products;
select * from regions;
select * from customers;
select * from orders;

desc orders;

set sql_safe_updates = 0;


UPDATE orders
SET OrderDate = STR_TO_DATE(OrderDate, '%d-%m-%Y')
WHERE STR_TO_DATE(OrderDate, '%d-%m-%Y') IS NOT NULL;


SELECT * FROM orders
WHERE STR_TO_DATE(OrderDate, '%d-%m-%Y') IS NULL;

alter table orders
modify column OrderDate datetime;

UPDATE orders
SET `Ship Date` = STR_TO_DATE(`Ship Date`, '%d-%m-%Y')
WHERE STR_TO_DATE(`Ship Date`, '%d-%m-%Y') IS NOT NULL;

SELECT * FROM orders
WHERE STR_TO_DATE(OrderDate, '%d-%m-%Y') IS NULL;

alter table orders
modify column `Ship Date` datetime;

alter table orders
rename column `Product  Index` to `Product Index`;

select p.`Product Name`, count(o.OrderNumber) as `Total Orders` 
from orders o inner join products p 
on o.`Product Index` = p.`Index`
group by p.`Product Name`
order by `Total Orders` desc;

alter table orders 
rename column `Total Unit Cost` to `Cost Price`;

alter table orders 
rename column `Unit Price` to `Selling Price`;

select `Order Quantity`, `Selling Price`, `Cost Price`, `Total Revenue`,
round((`Selling Price`-`cost Price`)*`Order Quantity`,2) as `Total Profit`
from orders;

alter table orders
add column Profit double;

update orders
set Profit = round((`Selling Price`-`cost Price`)*`Order Quantity`,2);




