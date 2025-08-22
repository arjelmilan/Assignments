--1
select c.city ,avg(i.quantity * i.unit_price) as avg_order_value , count(distinct o.order_id ) as delivered_orders_count from
customers c 
join orders o on c.customer_id = o.customer_id
join order_items i on o.order_id = i.order_id
where o.status = 'delivered'
group by c.city
having count(distinct o.order_id) >=2;

--2
select c.customer_id ,c.full_name , p.category , count(distinct o.order_id) as orders_count
from customers c
join orders o on c.customer_id = o.customer_id 
join order_items i on o.order_id = i.order_id
join products p on i.product_id = p.product_id
group by c.customer_id ,c.full_name , p.category 
order by c.customer_id , orders_count desc

--3
select c.full_name 
from customers c
join orders o on c.customer_id = o.customer_id 
join order_items i on o.order_id = i.order_id
join products p on i.product_id = p.product_id
where p.category  = 'Electronics'
union
select c.full_name 
from customers c
join orders o on c.customer_id = o.customer_id 
join order_items i on o.order_id = i.order_id
join products p on i.product_id = p.product_id
where p.category  = 'Fitness'

select c.full_name
from customers c
join orders o on c.customer_id = o.customer_id 
join order_items i on o.order_id = i.order_id
join products p on i.product_id = p.product_id
where p.category  = 'Electronics'
intersect 
select c.full_name
from customers c
join orders o on c.customer_id = o.customer_id 
join order_items i on o.order_id = i.order_id
join products p on i.product_id = p.product_id
where p.category  = 'Fitness'

select c.full_name
from customers c
join orders o on c.customer_id = o.customer_id 
join order_items i on o.order_id = i.order_id
join products p on i.product_id = p.product_id
where p.category  = 'Electronics'
except
select c.full_name
from customers c
join orders o on c.customer_id = o.customer_id 
join order_items i on o.order_id = i.order_id
join products p on i.product_id = p.product_id
where p.category  = 'Fitness'