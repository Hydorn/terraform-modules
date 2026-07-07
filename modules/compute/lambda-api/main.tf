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
  # Keyed by index rather than toset(var.role_policy_arns) directly: when an
  # ARN comes from a resource created in this same apply (e.g. an
  # aws_iam_policy created alongside this module), its value is unknown at
  # plan time, and for_each requires statically-known keys. Indices are
  # known as soon as the list's length is (a static-length list literal
  # with unknown element values still has a known length).
  for_each   = { for idx, arn in var.role_policy_arns : tostring(idx) => arn }
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

  # CI updates the deployed code directly (aws lambda update-function-code),
  # out-of-band from Terraform, on every app deploy — the same pattern the
  # ecr/repository module's README describes for image-based consumers.
  # Without this, every subsequent apply would diff the code-related
  # attributes against whatever filename/image_uri still points at
  # (typically an initial placeholder) and silently revert real deployed
  # code back to it.
  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash,
      s3_bucket,
      s3_key,
      s3_object_version,
      image_uri,
    ]
  }
}
