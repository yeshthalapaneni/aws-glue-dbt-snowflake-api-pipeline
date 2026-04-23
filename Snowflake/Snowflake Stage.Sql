-- Snowflake External Stage Configuration
-- Connects Snowflake to S3 for data ingestion

USE DATABASE API_PIPELINE_DB;
USE SCHEMA STAGING;

-- -----------------------------
-- Create Storage Integration (Recommended for production)
-- -----------------------------
-- Note: Requires account-level privileges

CREATE STORAGE INTEGRATION IF NOT EXISTS S3_INT_API_PIPELINE
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = S3
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::<your-account-id>:role/<your-snowflake-role>'
STORAGE_ALLOWED_LOCATIONS = ('s3://your-s3-bucket-name/');

-- After creating integration, run:
-- DESC INTEGRATION S3_INT_API_PIPELINE;
-- and update your AWS IAM role trust relationship accordingly

-- -----------------------------
-- Create External Stage
-- -----------------------------

CREATE OR REPLACE STAGE API_S3_STAGE
URL = 's3://your-s3-bucket-name/raw/api_data/'
STORAGE_INTEGRATION = S3_INT_API_PIPELINE
FILE_FORMAT = JSON_FILE_FORMAT;

-- -----------------------------
-- Test Stage Access
-- -----------------------------

-- LIST @API_S3_STAGE;

-- -----------------------------
-- Notes
-- -----------------------------
-- This stage allows Snowflake to directly read files from S3.
-- dbt macros will use this stage to load data into staging tables.
--
-- Make sure:
-- 1. The S3 bucket path matches your Glue output
-- 2. IAM role trust relationship is configured correctly
-- 3. Snowflake has permission to access the S3 bucket
