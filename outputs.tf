output "api_gateway_url" {
  description = "API Gateway invoke URL"
  value       = module.api_gateway.invoke_url
}

output "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  value       = module.cognito.user_pool_id
}

output "cognito_app_client_id" {
  description = "Cognito App Client ID"
  value       = module.cognito.app_client_id
}

output "knowledge_base_id" {
  description = "Bedrock Knowledge Base ID"
  value       = module.bedrock_kb.knowledge_base_id
}

output "admin_guardrail_id" {
  description = "Admin Guardrail ID (no PII masking)"
  value       = module.guardrails.admin_guardrail_id
}

output "non_admin_guardrail_id" {
  description = "Non-Admin Guardrail ID (PII masking enabled)"
  value       = module.guardrails.non_admin_guardrail_id
}
