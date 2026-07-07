variable "zone_id" {
  description = "Hosted zone ID to create the record in (e.g. dns/hosted-zone module's zone_id output)."
  type        = string
}

variable "record_name" {
  description = "Fully-qualified record name, e.g. \"collectiontracker.wow.emanuelrv.dev\"."
  type        = string
}

variable "type" {
  description = "Record type."
  type        = string
  default     = "A"
}

variable "alias_target_dns_name" {
  description = <<-EOT
    DNS name of the alias target. Populate from whichever edge module you're pointing at:
    CloudFront distribution domain_name, ALB dns_name, or API Gateway domain_name_configuration
    target_domain_name.
  EOT
  type        = string
}

variable "alias_target_zone_id" {
  description = <<-EOT
    Hosted zone ID of the alias target (CloudFront's is always Z2FDTNDATAQYW2; ALB and API
    Gateway custom domains expose their own zone_id attribute).
  EOT
  type        = string
}

variable "evaluate_target_health" {
  description = "Whether Route53 should evaluate the alias target's health."
  type        = bool
  default     = false
}
