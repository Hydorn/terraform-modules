resource "aws_route53_zone" "this" {
  count   = var.create_zone ? 1 : 0
  name    = var.domain_name
  comment = var.comment

  tags = var.tags
}

data "aws_route53_zone" "this" {
  count        = var.create_zone ? 0 : 1
  name         = var.domain_name
  private_zone = false
}
