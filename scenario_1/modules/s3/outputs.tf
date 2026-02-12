output "source_bucket_id" {
  value = aws_s3_bucket.source.id
}

output "source_bucket_arn" {
  value = aws_s3_bucket.source.arn
}

output "processing_bucket_id" {
  value = aws_s3_bucket.processing.id
}

output "redacted_bucket_id" {
  value = aws_s3_bucket.redacted.id
}

output "redacted_bucket_arn" {
  value = aws_s3_bucket.redacted.arn
}

output "quarantine_bucket_id" {
  value = aws_s3_bucket.quarantine.id
}
