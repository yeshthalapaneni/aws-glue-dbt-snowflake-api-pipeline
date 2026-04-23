-- Staging model for API data
-- Purpose: parse semi-structured JSON (VARIANT) into a cleaner, queryable shape

{{ config(
    materialized='view'
) }}

with source as (

    select
        raw,
        ingestion_timestamp
    from {{ source('staging', 'stg_api_data') }}

),

parsed as (

    select
        -- Example fields (adjust based on your API response)
        raw:id::string                as id,
        raw:name::string              as name,
        raw:status::string            as status,
        raw:created_at::timestamp     as created_at,
        raw:updated_at::timestamp     as updated_at,

        ingestion_timestamp

    from source

)

select * from parsed
