variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "prefix" {
  description = "Resource naming prefix (e.g. 'myorg-rag')"
  type        = string
  default     = "secure-rag"
}
