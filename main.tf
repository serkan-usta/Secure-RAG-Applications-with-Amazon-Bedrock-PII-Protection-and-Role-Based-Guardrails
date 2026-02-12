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
      ManagedBy = "terraform"
    }
  }
}

module "cognito" {
  source        = "./modules/cognito"
  prefix        = var.prefix
  create_groups = true
  groups        = ["admin", "non-admin"]
}

module "opensearch" {
  source = "./modules/opensearch"
  prefix = var.prefix
}

module "bedrock_kb" {
  source              = "./modules/bedrock_kb"
  prefix              = var.prefix
  collection_arn      = module.opensearch.collection_arn
  embedding_model_arn = "arn:aws:bedrock:${var.aws_region}::foundation-model/amazon.titan-embed-text-v2:0"
}

module "guardrails" {
  source = "./modules/guardrails"
  prefix = var.prefix
}

module "lambda" {
  source                 = "./modules/lambda"
  prefix                 = var.prefix
  knowledge_base_id      = module.bedrock_kb.knowledge_base_id
  admin_guardrail_id     = module.guardrails.admin_guardrail_id
  non_admin_guardrail_id = module.guardrails.non_admin_guardrail_id
}

module "api_gateway" {
  source                = "./modules/api_gateway"
  prefix                = var.prefix
  lambda_invoke_arn     = module.lambda.orchestrator_invoke_arn
  cognito_user_pool_arn = module.cognito.user_pool_arn
}
