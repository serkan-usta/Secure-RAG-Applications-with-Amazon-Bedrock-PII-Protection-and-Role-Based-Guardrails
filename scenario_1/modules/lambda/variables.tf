variable "prefix" {
  type = string
}

variable "s3_source_bucket" {
  type = string
}

variable "s3_redacted_bucket" {
  type = string
}

variable "s3_quarantine_bucket" {
  type = string
}

variable "dynamodb_table_name" {
  type = string
}

variable "dynamodb_table_arn" {
  type = string
}
