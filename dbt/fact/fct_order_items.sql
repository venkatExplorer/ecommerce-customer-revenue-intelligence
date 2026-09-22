select
    oi.order_id,
    oi.product_id,
    oi.quantity,
    oi.unit_price,
    oi.line_amount,

    p.product_name,
    p.category,
    p.sub_category,
    p.brand,
    p.cost,

    oi.quantity * p.cost as item_cost,

    oi.line_amount - (oi.quantity * p.cost) as item_profit

from {{ ref('stg_order_items') }} oi

left join {{ ref('dim_products') }} p
    on oi.product_id = p.product_id
