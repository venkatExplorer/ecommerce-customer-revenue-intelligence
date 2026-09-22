select *
from {{ source('ecommerce', 'deliveries_clean') }}
