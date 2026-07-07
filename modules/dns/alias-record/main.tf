resource "aws_route53_record" "this" {
  zone_id = var.zone_id
  name    = var.record_name
  type    = var.type

  alias {
    name                   = var.alias_target_dns_name
    zone_id                = var.alias_target_zone_id
    evaluate_target_health = var.evaluate_target_health
  }
}
