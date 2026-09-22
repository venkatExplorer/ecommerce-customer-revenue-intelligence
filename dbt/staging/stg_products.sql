select *
from {{ source('ecommerce', 'products_clean') }}
