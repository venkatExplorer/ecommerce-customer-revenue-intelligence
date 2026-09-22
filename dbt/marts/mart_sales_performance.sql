select
    o.order_id,
    o.order_date,
    o.customer_id,
    o.seller_id,
    o.order_status,
    o.payment_method,

    oi.product_id,
    oi.quantity,
    oi.unit_price,
    oi.line_amount,

    p.product_name,
    p.category,
    p.sub_category,
    p.brand,

    c.first_name,
    c.city,
    c.state,
    c.customer_segment,

    o.total_amount as order_value

from {{ ref('stg_orders') }} o

left join {{ ref('stg_order_items') }} oi
    on o.order_id = oi.order_id

left join {{ ref('stg_products') }} p
    on oi.product_id = p.product_id

left join {{ ref('stg_customers') }} c
    on o.customer_id = c.customer_id
