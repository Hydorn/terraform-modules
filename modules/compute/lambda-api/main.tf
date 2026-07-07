locals {
  full_name = "${var.name_prefix}-${var.app_name}"
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${local.full_name}"
  retention_in_days = var.log_retention_in_days

  tags = var.tags
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "${local.full_name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "basic_execution" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "vpc_access" {
  count      = length(var.subnet_ids) > 0 ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy" "secrets" {
  count = length(var.secrets_manager_arns) > 0 ? 1 : 0
  name  = "${local.full_name}-secrets"
  role  = aws_iam_role.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = var.secrets_manager_arns
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "extra" {
  for_each   = toset(var.role_policy_arns)
  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_lambda_function" "this" {
  function_name = local.full_name
  role          = aws_iam_role.this.arn
  package_type  = var.package_type

  filename          = var.package_type == "Zip" ? var.filename : null
  s3_bucket         = var.package_type == "Zip" ? var.s3_bucket : null
  s3_key            = var.package_type == "Zip" ? var.s3_key : null
  s3_object_version = var.package_type == "Zip" ? var.s3_object_version : null
  source_code_hash  = var.package_type == "Zip" && var.filename != null ? filebase64sha256(var.filename) : null
  handler           = var.package_type == "Zip" ? var.handler : null
  runtime           = var.package_type == "Zip" ? var.runtime : null

  image_uri = var.package_type == "Image" ? var.image_uri : null

  memory_size = var.memory_size
  timeout     = var.timeout

  environment {
    variables = var.environment
  }

  dynamic "vpc_config" {
    for_each = length(var.subnet_ids) > 0 ? [1] : []
    content {
      subnet_ids         = var.subnet_ids
      security_group_ids = var.security_group_ids
    }
  }

  tags = var.tags

  depends_on = [aws_cloudwatch_log_group.this]
}
