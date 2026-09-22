select
    *
from {{ ref('stg_customer_sessions') }}
