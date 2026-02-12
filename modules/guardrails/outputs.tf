output "admin_guardrail_id" {
  value = aws_bedrock_guardrail.admin.guardrail_id
}

output "non_admin_guardrail_id" {
  value = aws_bedrock_guardrail.non_admin.guardrail_id
}
