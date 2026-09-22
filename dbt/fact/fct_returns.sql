select
    return_id,
    order_id,
    product_id,
    return_date,
    return_reason,
    return_status,
    refund_amount

from {{ ref('stg_returns') }}
