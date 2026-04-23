# Architecture

## Overview

This project implements a cloud-based ELT pipeline that ingests data from an external API, lands it in Amazon S3 as raw JSON, and uses dbt to load and transform the data in Snowflake. The design separates ingestion, storage, and transformation concerns to keep the system simple, scalable, and maintainable.

## High-Level Flow

1. **Ingestion (AWS Glue)**

   * A scheduled AWS Glue job calls the external API.
   * The response is written to S3 as JSON files.

2. **Raw Storage (Amazon S3)**

   * S3 acts as the durable landing zone.
   * Files are stored with a timestamped key for traceability and reprocessing.

3. **Load (Snowflake External Stage + dbt Macro)**

   * Snowflake reads data from S3 via an external stage.
   * A dbt macro executes `COPY INTO` to load files into a staging table (`STAGING.STG_API_DATA`).

4. **Transform (dbt Models)**

   * **Staging**: Parse JSON (VARIANT) into typed columns.
   * **Raw**: Standardize types and apply light deduplication.
   * **Transform**: Apply business logic and enrich fields.
   * **Mart**: Produce analytics-ready aggregates for reporting.

5. **Consumption**

   * Mart tables are ready for BI tools, dashboards, or downstream services.

## Components

### AWS Glue

* Handles API extraction and S3 writes.
* Stateless job with logging and retry capability.

### Amazon S3

* Stores raw, immutable JSON files.
* Enables replay and backfills if needed.

### Snowflake

* Stores semi-structured data in VARIANT for initial load.
* Uses external stages and file formats for S3 ingestion.
* Provides scalable compute for transformations.

### dbt

* Orchestrates loading via macros and `COPY INTO`.
* Defines transformation logic as version-controlled SQL models.
* Enforces testing and documentation through `schema.yml`.

## Data Contracts and Conventions

* **File Format**: JSON with `STRIP_OUTER_ARRAY = TRUE` to handle array payloads.
* **Staging Table**: `STAGING.STG_API_DATA (raw VARIANT, ingestion_timestamp TIMESTAMP)`.
* **Naming**:

  * `stg_*` for staging views
  * `raw_*` for base tables
  * `trf_*` for transformed tables
  * `fct_*` / `dim_*` for mart models

## Operational Considerations

* **Idempotency**: S3 keys include timestamps; dbt models can deduplicate using latest ingestion.
* **Error Handling**: Glue job logs failures; `ON_ERROR='CONTINUE'` during load can be tightened later.
* **Cost Control**: Snowflake warehouse is set to auto-suspend; small size is sufficient for this workload.

## Extensions

* Add orchestration (Airflow) to coordinate Glue and dbt runs.
* Introduce incremental models for large datasets.
* Add data quality checks (dbt tests, expectations).
* Implement monitoring and alerting for job failures.
