select *
from {{ source('ecommerce', 'marketing_campaigns_clean') }}
