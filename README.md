# Secure RAG Applications with Amazon Bedrock — PII Protection & Role-Based Guardrails

> **Infrastructure as Code** — Full Terraform implementation of the AWS architecture patterns 

---

## Overview

This repository provides production-ready Terraform modules to deploy two security patterns for RAG (Retrieval Augmented Generation) applications on AWS, protecting sensitive data (PII/PHI) throughout the entire pipeline.

| Pattern | Description |
|---|---|
| **Scenario 1** | PII redaction at ingestion time — data is sanitized *before* entering the vector store |
| **Scenario 2** | Role-Based Access Control (RBAC) — admin vs non-admin guardrails at retrieval time |

---

## Architecture

### Scenario 1 — PII Redaction at Storage Level

1. Documents uploaded to S3 trigger an EventBridge → Lambda pipeline
2. **Amazon Comprehend** detects and redacts PII entities (`[NAME]`, `[SSN]`, etc.)
3. **Amazon Macie** performs secondary verification; high-severity files go to quarantine
4. Clean documents are ingested into the Bedrock Knowledge Base
5. At retrieval time, **Bedrock Guardrails** apply input/output content policies

### Scenario 2 — Role-Based Access Control (RBAC)

1. Users authenticate via **Amazon Cognito**
2. **API Gateway** forwards JWT claims to Lambda
3. Lambda checks user role → applies **admin** or **non-admin** guardrail
4. Admin users: full data access, no PII masking
5. Non-admin users: metadata-filtered retrieval + PII masking on output

---

## Repository Structure
```
.
├── scenario_1/                  # Scenario 1: PII Redaction at Ingestion
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── scenario_2/                  # Scenario 2: RBAC at Retrieval
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── modules/
│   ├── cognito/
│   ├── api_gateway/
│   ├── lambda/
│   ├── s3/
│   ├── bedrock_kb/
│   ├── opensearch/
│   ├── guardrails/
│   └── kms/
└── docs/
```

---

## AWS Services Used

- **Amazon Bedrock** — Knowledge Bases, Guardrails, Foundation Models
- **Amazon Cognito** — Authentication & JWT token generation
- **Amazon API Gateway** — REST API endpoint
- **AWS Lambda** — Conversation orchestrator, Comprehend trigger, Macie monitor
- **Amazon Comprehend** — Async PII detection & redaction jobs
- **Amazon Macie** — Secondary PII verification & quarantine
- **Amazon OpenSearch Serverless** — Vector store for embeddings
- **Amazon S3** — Document storage (inputs, processing, redacted, quarantine)
- **Amazon DynamoDB** — Job tracking table
- **Amazon EventBridge** — Scheduled triggers (every 5 min)
- **AWS IAM** — Least-privilege roles & policies

---

## Prerequisites

- Terraform >= 1.5
- AWS CLI configured (`aws configure`)
- AWS account with Bedrock model access enabled (Claude 3 / Titan Text v2)

---

## Quick Start

### Deploy Scenario 1 — PII Redaction
```bash
cd scenario_1
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

### Deploy Scenario 2 — RBAC
```bash
cd scenario_2
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

---

## References

- [AWS Blog: Protect sensitive data in RAG applications with Amazon Bedrock](https://aws.amazon.com/blogs/machine-learning/protect-sensitive-data-in-rag-applications-with-amazon-bedrock/)
- [Amazon Bedrock Guardrails Documentation](https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails.html)
- [OWASP Top 10 for LLM Applications](https://owasp.org/www-project-top-10-for-large-language-model-applications/)

---

## License

MIT License
