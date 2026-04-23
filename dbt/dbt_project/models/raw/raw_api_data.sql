-- Raw model for API data
-- Purpose: create a lightly structured, persistent table from staging
-- This layer standardizes types and preserves source-level detail for traceability

{{ config(
    materialized='table'
) }}

with src as (

    select
        id,
        name,
        status,
        created_at,
        updated_at,
        ingestion_timestamp
    from {{ ref('stg_api_data') }}

),

casted as (

    select
        cast(id as string)                as id,
        cast(name as string)              as name,
        cast(status as string)            as status,
        cast(created_at as timestamp)     as created_at,
        cast(updated_at as timestamp)     as updated_at,
        cast(ingestion_timestamp as timestamp) as ingestion_timestamp
    from src

),

-- Optional: simple deduplication using latest ingestion per id
ranked as (

    select
        *,
        row_number() over (
            partition by id
            order by ingestion_timestamp desc
        ) as rn
    from casted

)

select
    id,
    name,
    status,
    created_at,
    updated_at,
    ingestion_timestamp
from ranked
where rn = 1
