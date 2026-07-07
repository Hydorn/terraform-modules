output "zone_id" {
  description = "Hosted zone ID, usable by acm/certificate and dns/alias-record."
  value       = var.create_zone ? aws_route53_zone.this[0].zone_id : data.aws_route53_zone.this[0].zone_id
}

output "name_servers" {
  description = <<-EOT
    Name servers for the zone. Only populated when create_zone = true (a newly created zone) —
    these must be manually copied to the parent zone/registrar as a one-time step outside
    Terraform. Null when looking up an existing zone via create_zone = false.
  EOT
  value       = var.create_zone ? aws_route53_zone.this[0].name_servers : null
}
