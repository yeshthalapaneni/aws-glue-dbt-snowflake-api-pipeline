# Setup Guide

This guide walks through setting up the full pipeline end to end. It assumes you have access to AWS and Snowflake.

## Prerequisites

* AWS account with permissions for S3, IAM, and Glue
* Snowflake account
* Python 3.9+
* dbt (Snowflake adapter)

Install dbt:

```bash
pip install dbt-snowflake
```

---

## 1. AWS Setup

### Create S3 Bucket

* Create a bucket (example: `api-pipeline-bucket`)
* Create a folder structure:

```
s3://api-pipeline-bucket/raw/api_data/
```

### Create IAM Role for Glue

* Go to IAM → Roles → Create Role
* Attach policies:

  * AmazonS3FullAccess (or scoped access to your bucket)
  * AWSGlueServiceRole

### Create Glue Job

* Upload `glue/job_script.py`
* Set runtime to Python 3
* Attach IAM role created above
* Add optional job parameters (recommended):

```
--API_URL=https://api.example.com/data
--S3_BUCKET=api-pipeline-bucket
--S3_PREFIX=raw/api_data/
```

Run the job once to verify files are written to S3.

---

## 2. Snowflake Setup

Run the SQL files in this order:

1. `snowflake/setup.sql`
2. `snowflake/file_format.sql`
3. `snowflake/stage.sql`

### Verify Stage Access

```sql
LIST @API_S3_STAGE;
```

You should see JSON files from S3.

---

## 3. dbt Setup

### Configure Profile

Copy:

```
dbt_project/profiles.yml.example → ~/.dbt/profiles.yml
```

Update with your Snowflake credentials.

### Install Dependencies

```bash
cd dbt_project
dbt deps
```

### Validate Connection

```bash
dbt debug
```

---

## 4. Load Data into Snowflake

Run the macro to load data:

```bash
dbt run-operation load_s3_to_stage \
  --args '{"target_table": "STAGING.STG_API_DATA", "stage_name": "API_S3_STAGE"}'
```

Verify:

```sql
SELECT * FROM STAGING.STG_API_DATA LIMIT 10;
```

---

## 5. Run Transformations

```bash
dbt run
```

This will create:

* staging views
* raw tables
* transform tables
* mart tables

---

## 6. Run Tests

```bash
dbt test
```

---

## 7. Generate Documentation

```bash
dbt docs generate
dbt docs serve
```

Open the browser to view lineage and model documentation.

---

## Common Issues

### S3 Access Denied

* Check IAM role permissions
* Verify Snowflake storage integration trust relationship

### dbt Connection Failure

* Check account identifier format
* Verify role, warehouse, and database names

### Empty Tables

* Confirm Glue job wrote files to S3
* Confirm stage path matches S3 prefix

---

## Notes

This setup is intentionally simple but structured to reflect real-world patterns. You can extend this by adding orchestration, monitoring, and incremental processing as needed.
