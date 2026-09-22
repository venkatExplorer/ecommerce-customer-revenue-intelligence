select
    campaign_id,
    campaign_name,
    channel,
    start_date,
    end_date,
    budget,
    spend

from {{ ref('stg_marketing_campaigns') }}
