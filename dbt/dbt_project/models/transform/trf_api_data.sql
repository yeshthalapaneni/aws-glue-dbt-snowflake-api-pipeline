-- Transform model for API data
-- Purpose: apply business logic, clean fields, and prepare reusable datasets

{{ config(
    materialized='table'
) }}

with src as (

    select *
    from {{ ref('raw_api_data') }}

),

cleaned as (

    select
        id,
        trim(name) as name,

        -- Normalize status values
        case
            when lower(status) in ('active', 'enabled') then 'active'
            when lower(status) in ('inactive', 'disabled') then 'inactive'
            else 'unknown'
        end as status,

        created_at,
        updated_at,
        ingestion_timestamp

    from src

),

-- Example derived fields
enriched as (

    select
        id,
        name,
        status,

        created_at,
        updated_at,

        datediff('day', created_at, current_timestamp()) as days_since_created,

        ingestion_timestamp

    from cleaned

)

select * from enriched
