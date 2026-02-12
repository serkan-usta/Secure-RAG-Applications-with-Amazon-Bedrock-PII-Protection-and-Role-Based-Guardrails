output "orchestrator_invoke_arn" {
  value = aws_lambda_function.orchestrator.invoke_arn
}

output "orchestrator_name" {
  value = aws_lambda_function.orchestrator.function_name
}
