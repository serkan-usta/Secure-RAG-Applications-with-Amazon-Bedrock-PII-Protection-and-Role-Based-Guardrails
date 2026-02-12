import os
import json
import boto3

bedrock = boto3.client("bedrock-agent-runtime")

KNOWLEDGE_BASE_ID      = os.environ["KNOWLEDGE_BASE_ID"]
ADMIN_GUARDRAIL_ID     = os.environ["ADMIN_GUARDRAIL_ID"]
NON_ADMIN_GUARDRAIL_ID = os.environ["NON_ADMIN_GUARDRAIL_ID"]

def lambda_handler(event, context):
    body        = json.loads(event.get("body", "{}"))
    query       = body.get("query", "")
    claims      = event.get("requestContext", {}).get("authorizer", {}).get("claims", {})
    groups      = claims.get("cognito:groups", "")
    is_admin    = "admin" in groups

    guardrail_id = ADMIN_GUARDRAIL_ID if is_admin else NON_ADMIN_GUARDRAIL_ID

    kwargs = {
        "input": {"text": query},
        "retrieveAndGenerateConfiguration": {
            "type": "KNOWLEDGE_BASE",
            "knowledgeBaseConfiguration": {
                "knowledgeBaseId": KNOWLEDGE_BASE_ID,
                "modelArn": "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-3-sonnet-20240229-v1:0",
                "generationConfiguration": {
                    "guardrailConfiguration": {
                        "guardrailId":      guardrail_id,
                        "guardrailVersion": "DRAFT"
                    }
                }
            }
        }
    }

    if not is_admin:
        kwargs["retrieveAndGenerateConfiguration"]["knowledgeBaseConfiguration"][
            "retrievalConfiguration"
        ] = {
            "vectorSearchConfiguration": {
                "filter": {
                    "equals": {
                        "key":   "role",
                        "value": "non-admin"
                    }
                }
            }
        }

    response = bedrock.retrieve_and_generate(**kwargs)
    answer   = response["output"]["text"]

    return {
        "statusCode": 200,
        "body": json.dumps({"answer": answer, "role": "admin" if is_admin else "non-admin"})
    }
