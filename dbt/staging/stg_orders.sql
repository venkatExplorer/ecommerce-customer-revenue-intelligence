select
    trim(order_id) as order_id,
    trim(customer_id) as customer_id,
    trim(seller_id) as seller_id,
    safe_cast(order_date as date) as order_date,
    trim(order_status) as order_status,
    trim(payment_method) as payment_method,
    safe_cast(total_amount as numeric) as total_amount

from {{ source('ecommerce', 'orders_clean') }}
