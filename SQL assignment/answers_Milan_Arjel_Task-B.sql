create or replace view vw_recent_orders_30d
select o.order_id , c.customer_id ,o.order_date, o.status,sum(i.quantity * i.unit_price) as order_total , abs(extract(day from age(CURRENT_DATE,o.order_date))) <= 30 as days
from customers c 
join orders o on c.customer_id = o.customer_id
join order_items i on i.order_id = o.order_id
where o.status <> 'cancelled' and o.order_date >= current_date - interval '30 days'
group by o.order_id , c.customer_id,o.order_date
order by o.order_date

select *
from products p
where p.product_id not in(select distinct i.product_id from order_items i)

select *
from (select c.city,
			p.category,
			sum(i.quantity*i.unit_price) as total_revenue,
			rank() over(partition by c.city order by sum(i.quantity*i.unit_price) desc) as rnk
from customers c 
join orders o on c.customer_id = o.customer_id
join order_items i on i.order_id = o.order_id
join products p on p.product_id = i.product_id
group by c.city,p.category) ranked
where rnk = 1


select c.customer_id, c.full_name
from customers c
where not exists (
    select 1
    from orders o
    where o.customer_id = c.customer_id
      and o.status = 'delivered'
);
