select *
from {{ source('ecommerce', 'customer_sessions_clean') }}
