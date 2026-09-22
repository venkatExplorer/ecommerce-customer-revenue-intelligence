select *
from {{ source('ecommerce', 'sellers_clean') }}
