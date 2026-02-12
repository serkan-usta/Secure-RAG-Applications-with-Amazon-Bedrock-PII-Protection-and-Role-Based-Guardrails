output "comprehend_lambda_arn" {
  value = aws_lambda_function.comprehend.arn
}

output "comprehend_lambda_name" {
  value = aws_lambda_function.comprehend.function_name
}
