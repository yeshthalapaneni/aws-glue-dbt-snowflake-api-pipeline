# AWS Glue + dbt + Snowflake API Pipeline

A production-style ELT pipeline that extracts data from an external API using AWS Glue, stores raw JSON files in Amazon S3, and uses dbt macros and models to load, transform, and serve analytics-ready datasets in Snowflake.

## Overview

This project demonstrates a modern cloud data pipeline built around a simple and scalable ingestion pattern. Data is pulled from an external API using AWS Glue, written to Amazon S3 in raw JSON format, and then loaded into Snowflake through dbt-driven automation. Once the data is available in Snowflake, dbt models organize it into structured layers for downstream analytics.

The goal of this project is to show a clean separation between ingestion, storage, and transformation while following a maintainable analytics engineering workflow.

## Architecture

End-to-end flow:

1. AWS Glue extracts data from an external API.
2. Raw API responses are stored in Amazon S3 as JSON files.
3. dbt macros automate loading data from S3 into Snowflake staging tables.
4. dbt models transform the data across raw, transform, and mart layers.
5. Final Snowflake tables are ready for reporting, analysis, and downstream consumption.

## Project Objectives

This project is designed to demonstrate:

* API-based cloud data ingestion using AWS Glue
* durable raw storage in Amazon S3
* automated loading into Snowflake using dbt macros
* layered ELT modeling using dbt
* a clean and modular project structure suitable for real-world workflows

## Tech Stack

* AWS Glue
* Amazon S3
* Python
* dbt
* Snowflake
* SQL

## Repository Structure

```text
aws-glue-dbt-snowflake-api-pipeline/
│
├── README.md
├── requirements.txt
├── .gitignore
│
├── docs/
│   ├── architecture.md
│   └── setup-guide.md
│
├── glue/
│   ├── job_script.py
│   ├── config.py
│   └── utils.py
│
├── sample_data/
│   └── api_response_sample.json
│
├── snowflake/
│   ├── setup.sql
│   ├── file_format.sql
│   ├── stage.sql
│   └── warehouse_roles.sql
│
└── dbt_project/
    ├── dbt_project.yml
    ├── packages.yml
    ├── profiles.yml.example
    ├── macros/
    │   ├── create_external_stage.sql
    │   └── load_s3_to_stage.sql
    └── models/
        ├── staging/
        ├── raw/
        ├── transform/
        └── mart/
```

## Data Flow

### 1. API Extraction

AWS Glue runs a Python job that connects to an external API, requests data, and prepares the response for storage.

### 2. Raw Storage in S3

The extracted payload is written to Amazon S3 in JSON format. This S3 layer acts as the raw landing zone and preserves the source response before transformation.

### 3. Snowflake Staging Load

dbt macros are used to automate the loading process from S3 into Snowflake staging tables. This keeps the load logic modular and reusable.

### 4. Transformation with dbt

Once the raw data is available in Snowflake, dbt models transform it into structured datasets using layered modeling practices.

### 5. Analytics-Ready Outputs

The mart layer contains the final business-ready tables that can be used by BI tools, dashboards, or downstream analytical workloads.

## Data Modeling Approach

The project follows a layered data modeling design.

### Staging

The staging layer prepares the source data for downstream modeling. It handles light cleanup, parsing, and standardization.

### Raw

The raw layer preserves a structured representation of source data loaded from the landing area.

### Transform

The transform layer applies business logic, normalizes columns, filters records, and prepares reusable transformed datasets.

### Mart

The mart layer contains curated, analytics-ready models designed for reporting and consumption.

## Key Features

* Automated API ingestion using AWS Glue
* JSON-based raw storage in Amazon S3
* dbt macro-driven loading into Snowflake
* Layered transformation design using dbt
* Clear separation between ingestion and transformation
* Project structure designed for readability and maintainability

## Setup Summary

### AWS Setup

* Create an IAM role for AWS Glue with access to S3 and required AWS services.
* Create an S3 bucket for raw API storage.
* Configure and deploy the AWS Glue job.

### Snowflake Setup

* Create a warehouse, database, schema, and required roles.
* Create a file format and external stage for S3-based ingestion.
* Prepare staging tables for dbt-driven loads.

### dbt Setup

* Configure the Snowflake connection in `profiles.yml`.
* Install project dependencies.
* Run dbt macros and models to load and transform the data.

## Example dbt Commands

```bash
dbt debug
dbt run
dbt test
dbt docs generate
dbt docs serve
```

## Future Improvements

Possible enhancements for the next version of this project:

* Add orchestration using Apache Airflow
* Add incremental load logic for API ingestion
* Introduce data quality validation with dbt tests and Great Expectations
* Add CI checks for SQL quality and model validation
* Add metadata logging for ingestion runs
* Add monitoring and alerting for failed jobs

## Why This Project Matters

This project reflects a practical ELT pattern commonly used in modern cloud data platforms. It demonstrates how raw source data can be ingested and preserved in object storage, then transformed in a warehouse using modular SQL-based workflows. The combination of AWS Glue, S3, dbt, and Snowflake provides a clear example of scalable and maintainable data engineering design.

## Notes

This repository is intentionally structured as a clean reference implementation. It focuses on clarity, modularity, and separation of responsibilities across ingestion, storage, and transformation layers.
