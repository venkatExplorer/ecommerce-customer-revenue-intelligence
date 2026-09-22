select
    delivery_id,
    order_id,
    delivery_partner,
    shipped_date,
    expected_date,
    actual_date,
    delivery_status,

    case
        when actual_date > expected_date then 1
        else 0
    end as is_late_delivery,

    date_diff(
        actual_date,
        shipped_date,
        day
    ) as delivery_days

from {{ ref('stg_deliveries') }}
