-- Snowflake File Format Configuration
-- Defines how JSON files from S3 are parsed

USE DATABASE API_PIPELINE_DB;
USE SCHEMA STAGING;

-- -----------------------------
-- Create JSON File Format
-- -----------------------------

CREATE OR REPLACE FILE FORMAT JSON_FILE_FORMAT
TYPE = 'JSON'
COMPRESSION = 'AUTO'
STRIP_OUTER_ARRAY = TRUE
IGNORE_UTF8_ERRORS = TRUE;

-- -----------------------------
-- Notes
-- -----------------------------
-- STRIP_OUTER_ARRAY = TRUE ensures that if the API response is a JSON array,
-- each element is treated as a separate row during ingestion.
--
-- This file format will be used by the external stage and COPY INTO commands
-- when loading data from S3 into Snowflake.
