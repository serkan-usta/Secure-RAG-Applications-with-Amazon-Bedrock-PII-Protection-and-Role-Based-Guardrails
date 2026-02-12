# Secure RAG Applications with Amazon Bedrock — Role-Based Guardrails

> **Infrastructure as Code** — Terraform implementation of Role-Based Access Control (RBAC) for RAG applications on AWS using Amazon Bedrock.

---

## Overview

This repository provides Terraform modules to deploy a role-based access control pattern for RAG (Retrieval Augmented Generation) applications on AWS, protecting sensitive data (PII/PHI) during retrieval based on user roles.

---

## Architecture

![Architecture](docs/architecture.png)

### How It Works

1. Users authenticate via **Amazon Cognito**
2. **API Gateway** forwards JWT claims to Lambda
3. Lambda checks user role → applies **admin** or **non-admin** guardrail
4. Admin users: full data access, no PII masking
5. Non-admin users: metadata-filtered retrieval + PII masking on output

---

## Repository Structure
```
.
├── main.tf
├── variables.tf
├── outputs.tf
├── modules/
│   ├── cognito/
│   ├── api_gateway/
│   ├── lambda/
│   ├── bedrock_kb/
│   ├── opensearch/
│   ├── guardrails/
│   └── kms/
└── docs/
    └── architecture.png
```

---

## AWS Services Used

- **Amazon Bedrock** — Knowledge Bases, Guardrails, Foundation Models
- **Amazon Cognito** — Authentication & JWT token generation
- **Amazon API Gateway** — REST API endpoint
- **AWS Lambda** — Conversation orchestrator (RBAC logic)
- **Amazon OpenSearch Serverless** — Vector store for embeddings
- **AWS KMS** — Encryption at rest
- **AWS IAM** — Least-privilege roles & policies

---

## Prerequisites

- Terraform >= 1.5
- AWS CLI configured (`aws configure`)
- AWS account with Bedrock model access enabled (Claude 3 / Titan Text v2)

---

## Quick Start
```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
terraform init
terraform plan
terraform apply
```

---

## References

- [Amazon Bedrock Guardrails Documentation](https://docs.aws.amazon.com/bedrock/latest/userguide/guardrails.html)
- [OWASP Top 10 for LLM Applications](https://owasp.org/www-project-top-10-for-large-language-model-applications/)

---

## License

MIT License
