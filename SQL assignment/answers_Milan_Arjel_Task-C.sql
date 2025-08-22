--1
create or replace function fn_customer_lifetime_value(cust_id int)
returns numeric as $$
declare  total numeric;
begin
	select sum(i.quantity * i.unit_price) into total
	from (select o.order_id , o.customer_id from orders o where o.customer_id = 1 and o.status in ('delivered','shipped','placed')) oid
	join order_items i on oid.order_id = i.order_id;
	return total;
end
$$ language plpgsql;
select fn_customer_lifetime_value(1);

--2 
create or replace function fn_recent_orders(p_days int)
returns table (
    order_id int,
    customer_id int,
    order_date date,
    status varchar,
    order_total numeric
) as $$
begin
    return query
    select o.order_id, o.customer_id, o.order_date::date, o.status,
           sum(i.quantity * i.unit_price)
    from orders o
    join order_items i on o.order_id = i.order_id
    where o.order_date >= current_date - (p_days || ' days')::interval
    group by o.order_id, o.customer_id, o.order_date, o.status;
end;
$$ language plpgsql;

select * from fn_recent_orders(30);

--3
create or replace function fn_title_case_city(p_city text)
returns text
language sql
as $$
    select initcap(p_city);
$$;


select fn_title_case_city('kathmandu');
