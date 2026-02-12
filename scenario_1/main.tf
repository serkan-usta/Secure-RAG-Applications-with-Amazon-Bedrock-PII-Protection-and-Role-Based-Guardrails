terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Project   = "secure-rag-bedrock"
      Scenario  = "scenario-1-pii-redaction"
      ManagedBy = "terraform"
    }
  }
}

module "s3" {
  source = "./modules/s3"
  prefix = var.prefix
}

module "dynamodb" {
  source = "./modules/dynamodb"
  prefix = var.prefix
}

module "lambda" {
  source              = "./modules/lambda"
  prefix              = var.prefix
  s3_source_bucket    = module.s3.source_bucket_id
  s3_redacted_bucket  = module.s3.redacted_bucket_id
  s3_quarantine_bucket = module.s3.quarantine_bucket_id
  dynamodb_table_name = module.dynamodb.table_name
  dynamodb_table_arn  = module.dynamodb.table_arn
}

module "eventbridge" {
  source             = "./modules/eventbridge"
  prefix             = var.prefix
  lambda_arn         = module.lambda.comprehend_lambda_arn
  lambda_name        = module.lambda.comprehend_lambda_name
}
