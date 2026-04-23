{% macro create_external_stage(stage_name, s3_url, file_format, integration_name) %}

-- This macro creates an external stage in Snowflake
-- It allows dbt to manage stage creation if needed

CREATE OR REPLACE STAGE {{ stage_name }}
URL = '{{ s3_url }}'
STORAGE_INTEGRATION = {{ integration_name }}
FILE_FORMAT = {{ file_format }};

{% endmacro %}

-- Usage example:
-- {{ create_external_stage('API_S3_STAGE', 's3://your-bucket/raw/api_data/', 'JSON_FILE_FORMAT', 'S3_INT_API_PIPELINE') }}
