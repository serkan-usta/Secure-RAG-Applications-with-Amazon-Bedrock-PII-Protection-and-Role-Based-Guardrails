import os
import json
import boto3
import uuid
from datetime import datetime

s3 = boto3.client("s3")
comprehend = boto3.client("comprehend")
dynamodb = boto3.resource("dynamodb")

SOURCE_BUCKET     = os.environ["SOURCE_BUCKET"]
REDACTED_BUCKET   = os.environ["REDACTED_BUCKET"]
QUARANTINE_BUCKET = os.environ["QUARANTINE_BUCKET"]
DYNAMODB_TABLE    = os.environ["DYNAMODB_TABLE"]

def lambda_handler(event, context):
    table = dynamodb.Table(DYNAMODB_TABLE)

    response = s3.list_objects_v2(Bucket=SOURCE_BUCKET, Prefix="inputs/")
    files = response.get("Contents", [])

    for file in files:
        key = file["Key"]
        if key.endswith("/"):
            continue

        job_id = str(uuid.uuid4())

        s3.copy_object(
            Bucket=SOURCE_BUCKET,
            CopySource={"Bucket": SOURCE_BUCKET, "Key": key},
            Key=key.replace("inputs/", "processing/")
        )
        s3.delete_object(Bucket=SOURCE_BUCKET, Key=key)

        job_response = comprehend.start_pii_entities_detection_job(
            InputDataConfig={
                "S3Uri": f"s3://{SOURCE_BUCKET}/processing/",
                "InputFormat": "ONE_DOC_PER_FILE"
            },
            OutputDataConfig={"S3Uri": f"s3://{REDACTED_BUCKET}/for_macie_scan/"},
            Mode="ONLY_REDACTION",
            RedactionConfig={
                "PiiEntityTypes": ["NAME", "EMAIL", "PHONE", "SSN", "ADDRESS"],
                "MaskMode": "REPLACE_WITH_PII_ENTITY_TYPE"
            },
            LanguageCode="en",
            JobName=job_id,
            DataAccessRoleArn=context.invoked_function_arn
        )

        table.put_item(Item={
            "job_id":     job_id,
            "status":     "STARTED",
            "file_key":   key,
            "created_at": datetime.utcnow().isoformat()
        })

    return {"statusCode": 200, "body": json.dumps({"processed": len(files)})}
