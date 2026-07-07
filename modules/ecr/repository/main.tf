resource "aws_ecr_repository" "this" {
  name                 = var.name_prefix
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = var.tags
}

locals {
  lifecycle_rules = concat(
    [
      {
        rulePriority = 1
        description  = "Expire untagged images after ${var.untagged_image_expiry_days} days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = var.untagged_image_expiry_days
        }
        action = { type = "expire" }
      }
    ],
    length(var.tagged_image_tag_prefixes) > 0 ? [
      {
        rulePriority = 2
        description  = "Keep only the last ${var.tagged_image_keep_count} tagged images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = var.tagged_image_tag_prefixes
          countType     = "imageCountMoreThan"
          countNumber   = var.tagged_image_keep_count
        }
        action = { type = "expire" }
      }
    ] : []
  )
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    rules = local.lifecycle_rules
  })
}
