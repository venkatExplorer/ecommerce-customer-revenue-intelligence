select
    o.order_id,
    o.customer_id,
    o.seller_id,
    o.order_date,
    o.order_status,
    o.payment_method,
    o.total_amount,

    case
        when o.order_status = 'Delivered' then 1
        else 0
    end as is_delivered,

    case
        when o.order_status = 'Cancelled' then 1
        else 0
    end as is_cancelled,

    case
        when o.order_status = 'Returned' then 1
        else 0
    end as is_returned

from {{ ref('stg_orders') }} o
