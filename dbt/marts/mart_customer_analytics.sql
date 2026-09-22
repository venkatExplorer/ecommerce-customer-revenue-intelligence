select
    c.customer_id,
    c.first_name,
    c.city,
    c.state,
    c.customer_segment,
    c.signup_date,

    count(distinct o.order_id) as total_orders,

    countif(o.order_status = 'Delivered') as delivered_orders,

    countif(o.order_status = 'Cancelled') as cancelled_orders,

    countif(o.order_status = 'Returned') as returned_orders,

    round(sum(
        case
            when o.order_status = 'Delivered'
            then o.total_amount
            else 0
        end
    ), 2) as total_revenue,

    round(avg(
        case
            when o.order_status = 'Delivered'
            then o.total_amount
        end
    ), 2) as average_order_value,

    min(o.order_date) as first_order_date,

    max(o.order_date) as last_order_date,

    date_diff(
        max(o.order_date),
        min(o.order_date),
        day
    ) as customer_lifetime_days

from {{ ref('stg_customers') }} c

left join {{ ref('stg_orders') }} o
    on c.customer_id = o.customer_id

group by
    c.customer_id,
    c.first_name,
    c.city,
    c.state,
    c.customer_segment,
    c.signup_date
