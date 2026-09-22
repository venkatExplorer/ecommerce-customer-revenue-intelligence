select
    trim(customer_id) as customer_id,
    trim(first_name) as first_name,
    trim(last_name) as last_name,
    trim(gender) as gender,
    age,
    trim(city) as city,
    trim(state) as state,
    signup_date,
    trim(customer_segment) as customer_segment

from {{ source('ecommerce', 'customers_clean') }}
