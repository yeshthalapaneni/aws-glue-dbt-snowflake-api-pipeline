-- Mart model for API metrics
-- Purpose: provide analytics-ready aggregates for reporting

{{ config(
    materialized='table'
) }}

with src as (

    select *
    from {{ ref('trf_api_data') }}

),

aggregated as (

    select
        date_trunc('day', created_at) as created_date,
        status,

        count(*) as record_count,
        avg(days_since_created) as avg_days_since_created

    from src
    group by 1, 2

)

select
    created_date,
    status,
    record_count,
    avg_days_since_created
from aggregated
order by created_date desc, status
