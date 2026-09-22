select *
from {{ source('ecommerce', 'order_items_clean') }}
