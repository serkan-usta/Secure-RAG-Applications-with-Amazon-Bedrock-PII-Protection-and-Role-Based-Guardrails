output "s3_source_bucket" {
  description = "Upload documents here"
  value       = module.s3.source_bucket_id
}

output "s3_redacted_bucket" {
  description = "Redacted documents bucket"
  value       = module.s3.redacted_bucket_id
}

output "s3_quarantine_bucket" {
  description = "Quarantine bucket for high-severity files"
  value       = module.s3.quarantine_bucket_id
}

output "dynamodb_table" {
  description = "Job tracking table"
  value       = module.dynamodb.table_name
}
