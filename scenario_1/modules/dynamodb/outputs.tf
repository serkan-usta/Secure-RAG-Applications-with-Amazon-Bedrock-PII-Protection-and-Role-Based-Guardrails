output "table_name" {
  value = aws_dynamodb_table.job_tracking.name
}

output "table_arn" {
  value = aws_dynamodb_table.job_tracking.arn
}
