create or replace procedure sp_apply_category_discount(p_category text, p_percent numeric)
language plpgsql
as $$
begin
    update products
    set unit_price = unit_price * (1 - p_percent / 100.0)
    where category = p_category
      and is_active = true
      and unit_price * (1 - p_percent / 100.0) > 0;

end;
$$;

call sp_apply_category_discount('Electronics', 10);

create or replace procedure sp_cancel_order(p_order_id int)
language plpgsql
as $$
begin
    update orders
    set status = 'cancelled'
    where order_id = p_order_id
      and status <> 'delivered';

    delete from payments
    where order_id = p_order_id;

    raise notice 'Order % has been cancelled (if not already delivered).', p_order_id;
end;
$$;
call sp_cancel_order(3);  -- cancels order 3 if not delivered

create or replace procedure sp_reprice_stale_products(p_days int, p_increase numeric)
language plpgsql
as $$
begin
    -- Update products that have not been ordered in the last p_days
    update products p
    set unit_price = unit_price * (1 + p_increase/100.0)
    where p.active = true
      and not exists (
          select 1
          from order_items i
          join orders o on i.order_id = o.order_id
          where i.product_id = p.product_id
            and o.order_date >= current_date - (p_days || ' days')::interval
      );

    raise notice 'Stale products repriced by % percent.', p_increase;
end;
$$;
call sp_reprice_stale_products(30, 10);  
-- increases unit_price by 10% for products not ordered in the last 30 days

