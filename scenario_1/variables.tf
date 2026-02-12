variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "prefix" {
  description = "Resource naming prefix"
  type        = string
  default     = "secure-rag-s1"
}
