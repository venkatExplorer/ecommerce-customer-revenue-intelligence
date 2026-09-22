select *
from {{ source('ecommerce', 'payments_clean') }}
