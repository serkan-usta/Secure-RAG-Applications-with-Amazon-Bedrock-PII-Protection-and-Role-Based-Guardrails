data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_iam_role" "lambda" {
  name = "${var.prefix}-s1-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "basic" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "s1_policy" {
  name = "${var.prefix}-s1-policy"
  role = aws_iam_role.lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.s3_source_bucket}/*",
          "arn:aws:s3:::${var.s3_redacted_bucket}/*",
          "arn:aws:s3:::${var.s3_quarantine_bucket}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "comprehend:StartPiiEntitiesDetectionJob",
          "comprehend:DescribePiiEntitiesDetectionJob"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "macie2:CreateClassificationJob",
          "macie2:DescribeClassificationJob"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query"
        ]
        Resource = [var.dynamodb_table_arn]
      }
    ]
  })
}

data "archive_file" "comprehend_lambda" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/comprehend_lambda.zip"
}

resource "aws_lambda_function" "comprehend" {
  filename         = data.archive_file.comprehend_lambda.output_path
  function_name    = "${var.prefix}-comprehend-trigger"
  role             = aws_iam_role.lambda.arn
  handler          = "handler.lambda_handler"
  runtime          = "python3.11"
  source_code_hash = data.archive_file.comprehend_lambda.output_base64sha256
  timeout          = 60

  environment {
    variables = {
      SOURCE_BUCKET    = var.s3_source_bucket
      REDACTED_BUCKET  = var.s3_redacted_bucket
      QUARANTINE_BUCKET = var.s3_quarantine_bucket
      DYNAMODB_TABLE   = var.dynamodb_table_name
    }
  }
}
