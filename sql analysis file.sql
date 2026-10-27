create database  project_customer_beh;
use project_customer_beh;

select * from customer;

-- Q1. what is the total revenue generat  bythe male and femaal customer ?

select gender , sum(purchase_amount) as revenue
from customer
group by gender;



-- Q2. which customer used the discount but still spent more the average purchase amount?

select * from customer ;


select customer_id , purchase_amount
from customer
where discount_applied = "Yes" and purchase_amount >= (select avg(purchase_amount) from customer);


-- Q3 which are the  top 5 product with the higest average review rating ?

select * from customer ;

select item_purchased ,round(avg(review_rating),2)as avg_product_rating  from customer
group by item_purchased
order by avg_product_rating desc
limit 5;



-- Q4 compare the average purchase amount between standard and the express shiping

select * from customer;

select shipping_type ,
avg(purchase_amount)
from customer
where shipping_type in ("express" , "standard")
group by shipping_type;

-- Q5 do subscribe customer spend more ? compare average spend and total revenue
-- between subscribe and non subsribe customer 

select * from customer;

select subscription_status,
count(customer_id) as total_customer,
avg(purchase_amount)as  avg_spend,
SUM(purchase_amount)as  total_spend
from customer
group by  subscription_status
order by total_spend , avg_spend desc;

-- Q6 which 5 product have the higest percentage of purchase with discount applied?

select * from customer;

select item_purchased ,
100 * sum(case
			when discount_applied = "Yes" then 1 
            else 0
            end) / count(*) as discount_rate
		from customer
        group by item_purchased
        order by discount_rate desc
        limit 5;

-- Q7 segment customer is into new, returing and loyal based on their total 
-- number of previoues purchase and show the count of the each segment

select * from customer;

with customer_type as(
select customer_id ,previous_purchases,
case 
	when previous_purchases = 1 then "new"
    when previous_purchases between 2 And 10 then "Returing"
    else "loyal"
    end as customer_segment
    from customer
    )

select customer_segment , count(*) as "number of segment"
from customer_type
group by customer_segment;
	

-- what are the top 3 most expensive purchased product  with each category?
select * from customer;

with item_type as(
select item_purchased,
		category,
        count(customer_id) as total_order,
        row_number()over ( partition by category order by count(customer_id) desc) as item_rank
        from customer
        group by category, item_purchased
   )
   select item_rank , category, item_purchased, total_order
   from item_type
   where item_rank <=3 ;
   
   
-- Q9 are customer who are repat buyers ( more than 5 previouse purchase ) also likely to  subscribe ?

select subscription_status,
count(customer_id) as repate_buyers
from customer
where previous_purchases >=5
group by subscription_status;

-- Q10. what is the revenue contribution of each  age group?

select age_group,
sum(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc ;

