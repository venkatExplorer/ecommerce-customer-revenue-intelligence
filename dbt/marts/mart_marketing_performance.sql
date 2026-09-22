select
    campaign_id,
    campaign_name,
    channel,
    start_date,
    end_date,

    budget,
    spend,

    round(
        budget - spend,
        2
    ) as remaining_budget

from {{ ref('stg_marketing_campaigns') }}
