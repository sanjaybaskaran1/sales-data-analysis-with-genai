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

# lets create some views for report creation

use sales;

create or replace view top_10_customers as
select c.`Customer Names`, round(sum(o.`Total revenue`), 2) as `Total sales`,
round(sum(o.Profit), 2) as `Total Profit`
from orders o inner join customers c
on o.`Customer Name Index` = c.`Customer Index`
group by c.`Customer Names`
order by `Total Profit` desc
limit 10;



select * from top_10_customers;




create or replace view top_orders_placing_customers_by_city as
with cte as 
(
select r.`City`,c.`Customer Names`,round(count(o.OrderNumber), 2) as `Total orders`,
round(sum(o.Profit)) as `Total Profit`
from orders o inner join customers c 
on o.`Customer Name Index` = c.`Customer Index`
inner join regions r on r.`Index` = o.`Region Index`
group by r.`City`,c.`Customer Names`
order by `Total orders` desc
)
(
select `City`, `Customer Names`, `Total orders`, `Total Profit`,
dense_rank() over(partition by `City` order by `Total Orders` desc) as `rank`
from cte
) ;

select * from top_orders_placing_customers_by_city;

