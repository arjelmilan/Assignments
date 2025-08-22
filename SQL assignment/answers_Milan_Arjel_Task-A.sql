--1
select c.customer_id , extract(month from p.paid_at) as month,sum(p.amount) as total_monthly_spend,
rank() over(partition by(extract(month from p.paid_at)) order by sum(p.amount) desc) as rank_in_month
from customers c
join orders o on c.customer_id = o.customer_id
join payments p on o.order_id = p.order_id
group by c.customer_id , month

--2
select i.order_id ,p.product_name ,i.quantity , i.unit_price ,(i.unit_price*i.quantity) as revenue, i.unit_price / sum(i.unit_price*i.quantity) over (partition by o.order_id) as revenue_share
from customers c 
join orders o on c.customer_id = o.customer_id
join order_items i on i.order_id = o.order_id
join products p on i.product_id = p.product_id

--3 
select
    c.customer_id,
    c.full_name,
    o.order_id,
    o.order_date,
    lag(o.order_date) over (partition by c.customer_id order by o.order_date) as previous_order_date,
    extract(day from age(o.order_date, 
        lag(o.order_date) over (partition by c.customer_id order by o.order_date)
    )) as days_since_previous_order
from customers c
join orders o on c.customer_id = o.customer_id
order by c.customer_id, o.order_date;

--4 
select p.product_name, sum(i.quantity*i.unit_price) as total_revenue,NTILE(4) over(order by  sum(i.quantity*i.unit_price) desc) as quartile
from customers c 
join orders o on c.customer_id = o.customer_id
join order_items i on i.order_id = o.order_id
join products p on i.product_id = p.product_id
group by p.product_name

--5 
select distinct c.customer_id , c.full_name , first_value(o.order_date) over(partition by c.customer_id) as first_order,last_value(o.order_date) over(partition by c.customer_id) as recent_order
from customers c
join orders o on c.customer_id = o.customer_id
join order_items i on i.order_id = o.order_id
join products p on i.product_id = p.product_id
order by c.customer_id


