with product_sales as (

    select
        oi.product_id,

        count(distinct oi.order_id) as total_orders,

        sum(oi.quantity) as units_sold,

        sum(oi.line_amount) as total_revenue,

        sum(oi.quantity * p.cost) as total_cost,

        sum(
            oi.line_amount - (oi.quantity * p.cost)
        ) as total_profit

    from {{ ref('stg_order_items') }} oi

    left join {{ ref('stg_products') }} p
        on oi.product_id = p.product_id

    group by
        oi.product_id
)

select
    p.product_id,
    p.product_name,
    p.category,
    p.subcategory,
    p.brand,
    p.price,
    p.cost,

    coalesce(s.total_orders, 0) as total_orders,
    coalesce(s.units_sold, 0) as units_sold,

    round(coalesce(s.total_revenue, 0), 2) as total_revenue,

    round(coalesce(s.total_cost, 0), 2) as total_cost,

    round(coalesce(s.total_profit, 0), 2) as total_profit,

    round(
        safe_divide(
            s.total_profit,
            s.total_revenue
        ) * 100,
        2
    ) as profit_margin_percent

from {{ ref('stg_products') }} p

left join product_sales s
    on p.product_id = s.product_id
