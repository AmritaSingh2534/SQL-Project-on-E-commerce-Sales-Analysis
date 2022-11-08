create database p1;
use p1;
select * from [dbo].[olist_customers_dataset]
select * from [dbo].[olist_customers_dataset];
select * from dbo.olist_geolocation_dataset;
select * from dbo.olist_order_items_dataset;
select * from dbo.olist_order_payments_dataset;
select * from dbo.olist_orders_dataset;
select * from dbo.olist_products_dataset;
select * from dbo.olist_sellers_dataset;
select * from dbo.product_category_name_translation;
drop table [dbo].[olist_order_reviews_dataset]
drop view a1;
alter table [dbo].[olist_order_payments_dataset] alter column ["payment_value"] float;
alter table[dbo].[olist_order_items_dataset] alter column ["price"] float;
alter table[dbo].[olist_order_items_dataset] alter column ["freight_value"] float;
--a. Create the different metrics like --Sales, 
--- Sales

 select year([dbo].[olist_orders_dataset].["order_delivered_customer_date"])as years,[dbo].[olist_orders_dataset].["order_status"],
 [dbo].[olist_order_payments_dataset].["payment_value"],[dbo].[olist_customers_dataset].["customer_state"]
 from [dbo].[olist_customers_dataset] inner join [dbo].[olist_orders_dataset]
 on [dbo].[olist_orders_dataset].["customer_id"]=[dbo].[olist_customers_dataset].["customer_id"]
 inner join [dbo].[olist_order_payments_dataset]
 on [dbo].[olist_orders_dataset].["order_id"] = [dbo].[olist_order_payments_dataset].["order_id"]
 where [dbo].[olist_orders_dataset].["order_status"] = 'delivered';

 
--customer acquisitions, 
select [dbo].[olist_orders_dataset].["order_status"],[dbo].[olist_customers_dataset].["customer_unique_id"],
[dbo].[olist_customers_dataset].["customer_state"],year([dbo].[olist_orders_dataset].["order_approved_at"]) as years 
from [dbo].[olist_orders_dataset] inner join [dbo].[olist_customers_dataset] 
on [dbo].[olist_customers_dataset].["customer_id"]=[dbo].[olist_orders_dataset].["customer_id"]

create view customer_acq as 
select [dbo].[olist_orders_dataset].["order_status"],[dbo].[olist_customers_dataset].["customer_unique_id"],
[dbo].[olist_customers_dataset].["customer_state"],year([dbo].[olist_orders_dataset].["order_approved_at"]) as years 
from [dbo].[olist_orders_dataset] inner join [dbo].[olist_customers_dataset] 
on [dbo].[olist_customers_dataset].["customer_id"]=[dbo].[olist_orders_dataset].["customer_id"]

select ["order_status"],["customer_unique_id"],
["customer_state"], years,
row_number()over(order by years)
 as customer_diff_year from customer_acq
 where ["order_status"] ='delivered' and years= 2016 or years =2017 or years = 2018;

--total no. of orders for each Year across the different states they serve.
select [dbo].[olist_orders_dataset].["customer_id"],[dbo].[olist_orders_dataset].["order_id"],[dbo].[olist_orders_dataset].["order_status"],
year([dbo].[olist_orders_dataset].["order_delivered_customer_date"]) as years,[dbo].[olist_order_payments_dataset].["payment_value"],
[dbo].[olist_customers_dataset].["customer_state"]
from [dbo].[olist_orders_dataset] join [dbo].[olist_order_payments_dataset]
on [dbo].[olist_order_payments_dataset].["order_id"]=[dbo].[olist_orders_dataset].["order_id"]
join [dbo].[olist_order_items_dataset]on [dbo].[olist_orders_dataset].["order_id"]=[dbo].[olist_order_items_dataset].["order_id"]
join [dbo].[olist_customers_dataset] on [dbo].[olist_orders_dataset].["customer_id"]=[dbo].[olist_customers_dataset].["customer_id"]
where [dbo].[olist_orders_dataset].["order_status"]='delivered';

select o.[dbo].[olist_orders_dataset]customer_id, o.order_id, o.order_status, o.order_delivered_customer_date, p.payment_value, c.customer_city, c.customer_state 
from [dbo].[olist_orders_dataset] as o join [dbo].[olist_order_payments_dataset] as p on o.order_id=p.order_id 
join [dbo].[olist_order_items_dataset] as oi on o.order_id=oi.order_id join [dbo].[olist_customers_dataset] as c 
on o.customer_id=c.customer_id where order_status='delivered'

Does all the metrices show similar trends or is there any disparity amongst each of them?



--b. Using the above metrics, identify the top 2 States which show
--i. Declining trend over the years 
select dbo.olist_customers_dataset.["customer_state"], year([dbo].[olist_orders_dataset].["order_approved_at"]) as years, 
count([dbo].[olist_orders_dataset].["order_id"]) as total_orders from [dbo].[olist_orders_dataset] inner join [dbo].[olist_customers_dataset]
on [dbo].[olist_orders_dataset].["customer_id"]=[dbo].[olist_customers_dataset].["customer_id"] 
where year(["order_approved_at"]) in ('2016','2017','2018') 
group by dbo.olist_customers_dataset.["customer_state"], year([dbo].[olist_orders_dataset].["order_approved_at"])
order by total_orders asc;

create view declining_trend_state as 
select  dbo.olist_customers_dataset.["customer_state"], year([dbo].[olist_orders_dataset].["order_approved_at"]) as years, 
count([dbo].[olist_orders_dataset].["order_id"]) as total_orders from [dbo].[olist_orders_dataset] inner join [dbo].[olist_customers_dataset]
on [dbo].[olist_orders_dataset].["customer_id"]=[dbo].[olist_customers_dataset].["customer_id"] 
where year(["order_approved_at"]) in ('2016','2017','2018') 
group by dbo.olist_customers_dataset.["customer_state"], year([dbo].[olist_orders_dataset].["order_approved_at"]) order by total_orders asc;
 
 select * from declining_trend_state;


--ii. Increasing trend over the years
select top 2 dbo.olist_customers_dataset.["customer_state"], year([dbo].[olist_orders_dataset].["order_approved_at"]) as years, 
count([dbo].[olist_orders_dataset].["order_id"]) as total_orders from [dbo].[olist_orders_dataset] inner join [dbo].[olist_customers_dataset]
on [dbo].[olist_orders_dataset].["customer_id"]=[dbo].[olist_customers_dataset].["customer_id"] 
where year(["order_approved_at"]) in ('2016','2017','2018') 
group by dbo.olist_customers_dataset.["customer_state"], year([dbo].[olist_orders_dataset].["order_approved_at"])
order by total_orders desc;

create view increasing_trend_state as
select top 2 dbo.olist_customers_dataset.["customer_state"], year([dbo].[olist_orders_dataset].["order_approved_at"]) as years, 
count([dbo].[olist_orders_dataset].["order_id"]) as total_orders from [dbo].[olist_orders_dataset] inner join [dbo].[olist_customers_dataset]
on [dbo].[olist_orders_dataset].["customer_id"]=[dbo].[olist_customers_dataset].["customer_id"] 
where year(["order_approved_at"]) in ('2016','2017','2018') 
group by dbo.olist_customers_dataset.["customer_state"], year([dbo].[olist_orders_dataset].["order_approved_at"])order by total_orders desc;

select * from increasing_trend_state;

--c. For the States identified above, do the Root Cause analysis for their performance across a variety of metrics.

---Category level Sales 
select distinct ([dbo].[olist_products_dataset].["product_category_name"]),[dbo].[product_category_name_translation].[product_category_name_english],
year([dbo].[olist_orders_dataset].["order_approved_at"]) as years, count([dbo].[olist_order_items_dataset].["price"]) as total_sales
from [dbo].[olist_order_items_dataset] inner join [dbo].[olist_orders_dataset] 
on [dbo].[olist_order_items_dataset].["order_id"]=[dbo].[olist_orders_dataset].["order_id"]
inner join [dbo].[olist_products_dataset] on [dbo].[olist_order_items_dataset].["product_id"]=[dbo].[olist_products_dataset].["product_id"]
join [dbo].[product_category_name_translation] 
on [dbo].[product_category_name_translation].[product_category_name]=[dbo].[olist_products_dataset].["product_category_name"]
where [dbo].[olist_orders_dataset].["order_status"]= 'delivered' 
group by [dbo].[olist_products_dataset].["product_category_name"],[dbo].[product_category_name_translation].[product_category_name_english],
year([dbo].[olist_orders_dataset].["order_approved_at"]) order by [dbo].[olist_products_dataset].["product_category_name"];


--orders placed, 
select count(["order_id"]) as total_orders, 
year(dbo.olist_orders_dataset.["order_approved_at"]) as years from [dbo].[olist_orders_dataset] group by year(dbo.olist_orders_dataset.["order_approved_at"]);
--post-order reviews, 

--Seller performance in terms of deliveries,
 
select [dbo].[olist_sellers_dataset].["seller_id"] as sellers, [dbo].[olist_order_items_dataset].["order_item_id"] as order_item,
count([dbo].[olist_orders_dataset].["order_status"])as os
from [dbo].[olist_orders_dataset] join [dbo].[olist_order_items_dataset]
on [dbo].[olist_orders_dataset].["order_id"]=[dbo].[olist_order_items_dataset].["order_id"] join [dbo].[olist_sellers_dataset] 
on [dbo].[olist_sellers_dataset].["seller_id"]=[dbo].[olist_order_items_dataset].["seller_id"]
group by [dbo].[olist_sellers_dataset].["seller_id"] , [dbo].[olist_order_items_dataset].["order_item_id"];

create view a1 as 
select [dbo].[olist_sellers_dataset].["seller_id"] as sellers, [dbo].[olist_order_items_dataset].["order_item_id"] as order_item,
count([dbo].[olist_orders_dataset].["order_status"])as os
from [dbo].[olist_orders_dataset] join [dbo].[olist_order_items_dataset]
on [dbo].[olist_orders_dataset].["order_id"]=[dbo].[olist_order_items_dataset].["order_id"] join [dbo].[olist_sellers_dataset] 
on [dbo].[olist_sellers_dataset].["seller_id"]=[dbo].[olist_order_items_dataset].["seller_id"]
group by [dbo].[olist_sellers_dataset].["seller_id"] , [dbo].[olist_order_items_dataset].["order_item_id"];

select * from a1;

select [dbo].[olist_sellers_dataset].["seller_id"] as sellers, [dbo].[olist_order_items_dataset].["order_item_id"] as order_item,
count([dbo].[olist_orders_dataset].["order_status"])as os
from [dbo].[olist_orders_dataset] join [dbo].[olist_order_items_dataset] 
 on [dbo].[olist_orders_dataset].["order_id"]=[dbo].[olist_order_items_dataset].["order_id"] join [dbo].[olist_sellers_dataset] 
on [dbo].[olist_sellers_dataset].["seller_id"]=[dbo].[olist_order_items_dataset].["seller_id"]
where dbo.olist_orders_dataset.["order_status"]= 'delivered'
group by [dbo].[olist_sellers_dataset].["seller_id"] , [dbo].[olist_order_items_dataset].["order_item_id"];

create view b1 as 
select [dbo].[olist_sellers_dataset].["seller_id"] as sellers, [dbo].[olist_order_items_dataset].["order_item_id"] as order_item,
count([dbo].[olist_orders_dataset].["order_status"])as os
from [dbo].[olist_orders_dataset] join [dbo].[olist_order_items_dataset] 
 on [dbo].[olist_orders_dataset].["order_id"]=[dbo].[olist_order_items_dataset].["order_id"] join [dbo].[olist_sellers_dataset] 
on [dbo].[olist_sellers_dataset].["seller_id"]=[dbo].[olist_order_items_dataset].["seller_id"]
where dbo.olist_orders_dataset.["order_status"]= 'delivered'
group by [dbo].[olist_sellers_dataset].["seller_id"] , [dbo].[olist_order_items_dataset].["order_item_id"];

select * from b1;

select distinct [dbo].[a1].[sellers], [dbo].[b1].[order_item],[dbo].[a1].[os],[dbo].[b1].[os],
(100 * ([dbo].[b1].[os])/[dbo].[a1].[os]) as percent_of
from a1 right join b1 on [dbo].[a1].[sellers]=[dbo].[b1].[sellers]
where [dbo].[a1].[os] > [dbo].[b1].[os]
order by percent_of asc;


--product-level sales


--orders placed,

select count([dbo].[olist_orders_dataset].["customer_id"]) as orders_placed ,[dbo].[olist_orders_dataset].["order_status"],year([dbo].[olist_orders_dataset].["order_purchase_timestamp"]) as years,
 [dbo].[olist_geolocation_dataset].["geolocation_state"] as geolocation_state from [dbo].[olist_orders_dataset]
inner join [dbo].[olist_customers_dataset] on [dbo].[olist_customers_dataset].["customer_id"]=[dbo].[olist_orders_dataset].["customer_id"]
inner join [dbo].[olist_geolocation_dataset] on [dbo].[olist_customers_dataset].["customer_zip_code_prefix"]=[dbo].[olist_geolocation_dataset].["geolocation_zip_code_prefix"]
where [dbo].[olist_orders_dataset].["order_status"] != 'unavailable'
group by [dbo].[olist_orders_dataset].["order_status"], year([dbo].[olist_orders_dataset].["order_purchase_timestamp"]), [dbo].[olist_geolocation_dataset].["geolocation_state"];

create view orders as 
select count([dbo].[olist_orders_dataset].["customer_id"]) as orders_placed ,[dbo].[olist_orders_dataset].["order_status"],year([dbo].[olist_orders_dataset].["order_purchase_timestamp"]) as years,
 [dbo].[olist_geolocation_dataset].["geolocation_state"] as geolocation_state from [dbo].[olist_orders_dataset]
inner join [dbo].[olist_customers_dataset] on [dbo].[olist_customers_dataset].["customer_id"]=[dbo].[olist_orders_dataset].["customer_id"]
inner join [dbo].[olist_geolocation_dataset] on [dbo].[olist_customers_dataset].["customer_zip_code_prefix"]=[dbo].[olist_geolocation_dataset].["geolocation_zip_code_prefix"]
where [dbo].[olist_orders_dataset].["order_status"] != 'unavailable' 
group by [dbo].[olist_orders_dataset].["order_status"], year([dbo].[olist_orders_dataset].["order_purchase_timestamp"]), [dbo].[olist_geolocation_dataset].["geolocation_state"];

select * from orders;

select * from orders pivot (count(orders_placed) for geolocation_state in 
([AL],[RS],[ES],[RR],[RO],[PI],[MG], [AC],[SC],[MA], [bahia, brasil",BA],[SE],[SP],[RN],[PE],[TO],[MS],[RJ],[PA],[AP],[DF],[GO],[PB],[AM],[MT],[PR],[CE],[BA],[rio de janeiro, brasil",RJ])) as pvttable;

select * from orders pivot (count(orders_placed) for years in ([2016],[2017],[2018])) as pvttable;

select * from orders pivot (count(orders_placed) for [dbo].[orders].["order_status"] in ([canceled],[delivered],[shipped], [invoiced],[processing],[approved])) as pvttable;

--% of orders delivered earlier than the expected date,
--% of orders delivered later than the expected date, etc.

--customers 

-- 
---No of days taken by different sellers when the location of customer as well as seller is same.
select ([dbo].[olist_order_items_dataset].["seller_id"]),
datediff(day,[dbo].[olist_orders_dataset].["order_purchase_timestamp"],[dbo].[olist_orders_dataset].["order_delivered_customer_date"]) as no_of_days 
from  [dbo].[olist_orders_dataset] inner join [dbo].[olist_customers_dataset]
on [dbo].[olist_orders_dataset].["customer_id"]=[dbo].[olist_customers_dataset].["customer_id"]
inner join [dbo].[olist_geolocation_dataset]
on [dbo].[olist_customers_dataset].["customer_zip_code_prefix"]=[dbo].[olist_geolocation_dataset].["geolocation_zip_code_prefix"]
inner join [dbo].[olist_sellers_dataset] 
on [dbo].[olist_geolocation_dataset].["geolocation_zip_code_prefix"]=[dbo].[olist_sellers_dataset].["seller_zip_code_prefix"]
where [dbo].[olist_orders_dataset].["order_status"]= 'delivered' and  
[dbo].[olist_sellers_dataset].["seller_city"]=[dbo].[olist_customers_dataset].["customer_city"] 
and [dbo].[olist_sellers_dataset].["seller_state"]=[dbo].[olist_customers_dataset].["customer_state"];

select distinct([dbo].[olist_sellers_dataset].["seller_id"]),
datediff(day,[dbo].[olist_orders_dataset].["order_purchase_timestamp"],[dbo].[olist_orders_dataset].["order_delivered_customer_date"]) as no_of_days
from [dbo].[olist_orders_dataset] inner join [dbo].[olist_customers_dataset]
on [dbo].[olist_orders_dataset].["customer_id"]=[dbo].[olist_customers_dataset].["customer_id"]
inner join [dbo].[olist_geolocation_dataset]
on [dbo].[olist_customers_dataset].["customer_zip_code_prefix"]=[dbo].[olist_geolocation_dataset].["geolocation_zip_code_prefix"]
inner join [dbo].[olist_sellers_dataset]
on [dbo].[olist_geolocation_dataset].["geolocation_zip_code_prefix"]=[dbo].[olist_sellers_dataset].["seller_zip_code_prefix"]
where [dbo].[olist_orders_dataset].["order_status"]= 'delivered' and
[dbo].[olist_sellers_dataset].["seller_city"]=[dbo].[olist_customers_dataset].["customer_city"]
and [dbo].[olist_sellers_dataset].["seller_state"]=[dbo].[olist_customers_dataset].["customer_state"];

--- top 10 seller ids taking the least time.
select distinct top 10  ["seller_id"] from (select distinct([dbo].[olist_sellers_dataset].["seller_id"]),
datediff(day,[dbo].[olist_orders_dataset].["order_purchase_timestamp"],[dbo].[olist_orders_dataset].["order_delivered_customer_date"]) as no_of_days 
from [dbo].[olist_orders_dataset] inner join [dbo].[olist_customers_dataset]
on [dbo].[olist_orders_dataset].["customer_id"]=[dbo].[olist_customers_dataset].["customer_id"]
inner join [dbo].[olist_geolocation_dataset]
on [dbo].[olist_customers_dataset].["customer_zip_code_prefix"]=[dbo].[olist_geolocation_dataset].["geolocation_zip_code_prefix"]
inner join [dbo].[olist_sellers_dataset] 
on [dbo].[olist_geolocation_dataset].["geolocation_zip_code_prefix"]=[dbo].[olist_sellers_dataset].["seller_zip_code_prefix"]
where [dbo].[olist_orders_dataset].["order_status"]= 'delivered' and  
[dbo].[olist_sellers_dataset].["seller_city"]=[dbo].[olist_customers_dataset].["customer_city"] 
and [dbo].[olist_sellers_dataset].["seller_state"]=[dbo].[olist_customers_dataset].["customer_state"])a1;

---payment type used by different customers for different amount at the time of delivery in order to location 
--(here means modern cities or states will use online payment mode more when compared with others) 
select [dbo].[olist_order_payments_dataset].["payment_type"] as payment_mode,[dbo].[olist_customers_dataset].["customer_city"],
[dbo].[olist_customers_dataset].["customer_state"],[dbo].[olist_order_payments_dataset].["payment_value"] as amount
from [dbo].[olist_order_payments_dataset] inner join [dbo].[olist_orders_dataset]
on [dbo].[olist_order_payments_dataset].["order_id"]=[dbo].[olist_orders_dataset].["order_id"]
inner join [dbo].[olist_customers_dataset]
on [dbo].[olist_customers_dataset].["customer_id"]=[dbo].[olist_orders_dataset].["customer_id"]
where [dbo].[olist_orders_dataset].["order_status"]= 'delivered';

---total amount deal within different city and state by different mode of payments.
create view pays as 
select [dbo].[olist_order_payments_dataset].["payment_type"] as payment_mode,[dbo].[olist_customers_dataset].["customer_city"],
[dbo].[olist_customers_dataset].["customer_state"],[dbo].[olist_order_payments_dataset].["payment_value"] as amount
from [dbo].[olist_order_payments_dataset] inner join [dbo].[olist_orders_dataset]
on [dbo].[olist_order_payments_dataset].["order_id"]=[dbo].[olist_orders_dataset].["order_id"]
inner join [dbo].[olist_customers_dataset]
on [dbo].[olist_customers_dataset].["customer_id"]=[dbo].[olist_orders_dataset].["customer_id"]
where [dbo].[olist_orders_dataset].["order_status"]= 'delivered';

select * from pays pivot(sum(amount) for payment_mode in ([debit_card],[credit_card],[boleto],[voucher]))as pivott;

--calculated sale price(price+freight) of different product categories.
select distinct[dbo].[olist_products_dataset].["product_category_name"] as product_category,
([dbo].[olist_order_items_dataset].["price"] + [dbo].[olist_order_items_dataset].["freight_value"]) as sale_price 
from [dbo].[olist_order_items_dataset] inner join [dbo].[olist_products_dataset]
on [dbo].[olist_order_items_dataset].["product_id"]=[dbo].[olist_products_dataset].["product_id"];


--count of sales for different product category
select distinct [dbo].[olist_products_dataset].["product_id"], [dbo].[olist_products_dataset].["product_category_name"],count([dbo].[olist_orders_dataset].["order_id"]) as Count_of_sales
from [dbo].[olist_products_dataset] inner join [dbo].[olist_order_items_dataset]
on [dbo].[olist_order_items_dataset].["product_id"]=[dbo].[olist_products_dataset].["product_id"]
inner join[dbo].[olist_orders_dataset] 
on [dbo].[olist_orders_dataset].["order_id"]=[dbo].[olist_order_items_dataset].["order_id"]
where [dbo].[olist_orders_dataset].["order_status"]= 'delivered'
group by [dbo].[olist_products_dataset].["product_id"], [dbo].[olist_products_dataset].["product_category_name"];

