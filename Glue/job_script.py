"""
AWS Glue Job Script

This script extracts data from an external API and writes the response
as JSON files into an S3 bucket. It is designed to be simple, modular,
and production-friendly with basic logging and error handling.
"""

import sys
import json
import logging
import requests
from datetime import datetime

import boto3

# -----------------------------
# Configuration
# -----------------------------

API_URL = "https://api.example.com/data"  # replace with real API
S3_BUCKET = "your-s3-bucket-name"
S3_PREFIX = "raw/api_data/"
TIMEOUT = 30

# -----------------------------
# Logging Setup
# -----------------------------

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)

# -----------------------------
# S3 Client
# -----------------------------

s3_client = boto3.client("s3")

# -----------------------------
# Helper Functions
# -----------------------------

def fetch_api_data(url: str) -> dict:
    """Fetch data from the external API"""
    try:
        logger.info("Fetching data from API")
        response = requests.get(url, timeout=TIMEOUT)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.RequestException as e:
        logger.error(f"API request failed: {str(e)}")
        raise


def generate_s3_key(prefix: str) -> str:
    """Generate a timestamp-based S3 key"""
    timestamp = datetime.utcnow().strftime("%Y%m%d_%H%M%S")
    return f"{prefix}api_data_{timestamp}.json"


def write_to_s3(bucket: str, key: str, data: dict):
    """Write JSON data to S3"""
    try:
        logger.info(f"Writing data to s3://{bucket}/{key}")
        s3_client.put_object(
            Bucket=bucket,
            Key=key,
            Body=json.dumps(data),
            ContentType="application/json"
        )
    except Exception as e:
        logger.error(f"Failed to write to S3: {str(e)}")
        raise

# -----------------------------
# Main Execution
# -----------------------------

def main():
    try:
        logger.info("Starting Glue job execution")

        # Step 1: Extract
        data = fetch_api_data(API_URL)

        # Step 2: Generate S3 path
        s3_key = generate_s3_key(S3_PREFIX)

        # Step 3: Load to S3
        write_to_s3(S3_BUCKET, s3_key, data)

        logger.info("Glue job completed successfully")

    except Exception as e:
        logger.error(f"Glue job failed: {str(e)}")
        sys.exit(1)


if __name__ == "__main__":
    main()
