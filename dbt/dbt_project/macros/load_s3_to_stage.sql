{% macro load_s3_to_stage(target_table, stage_name, file_format='JSON_FILE_FORMAT') %}

-- This macro loads data from an S3-backed Snowflake stage into a staging table
-- It assumes the target table has columns: raw (VARIANT), ingestion_timestamp (TIMESTAMP)

COPY INTO {{ target_table }} (raw, ingestion_timestamp)
FROM (
    SELECT
        $1 AS raw,
        CURRENT_TIMESTAMP() AS ingestion_timestamp
    FROM @{{ stage_name }}
)
FILE_FORMAT = (FORMAT_NAME = {{ file_format }})
ON_ERROR = 'CONTINUE';

{% endmacro %}

-- Usage example:
-- {{ load_s3_to_stage('STAGING.STG_API_DATA', var('s3_stage_name')) }}
