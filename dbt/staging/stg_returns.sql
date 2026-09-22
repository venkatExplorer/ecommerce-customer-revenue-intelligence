select *
from {{ source('ecommerce', 'returns_clean') }}
