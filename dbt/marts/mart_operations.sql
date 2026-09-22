with delivery_metrics as (

    select
        delivery_partner,

        count(distinct order_id) as total_orders,

        countif(delivery_status = 'Delivered') as delivered_orders,

        countif(delivery_status = 'Not Shipped') as not_shipped_orders,

        countif(delivery_status = 'In Transit') as in_transit_orders,

        countif(is_late_delivery = 1) as late_deliveries,

        avg(delivery_days) as average_delivery_days

    from {{ ref('fct_deliveries') }}

    group by delivery_partner
)

select
    delivery_partner,
    total_orders,
    delivered_orders,
    not_shipped_orders,
    in_transit_orders,
    late_deliveries,

    round(
        safe_divide(
            delivered_orders,
            total_orders
        ) * 100,
        2
    ) as delivery_success_rate,

    round(
        safe_divide(
            late_deliveries,
            delivered_orders
        ) * 100,
        2
    ) as late_delivery_rate,

    round(average_delivery_days, 2) as average_delivery_days

from delivery_metrics
