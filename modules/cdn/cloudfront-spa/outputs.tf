output "distribution_id" {
  value = aws_cloudfront_distribution.this.id
}

output "distribution_arn" {
  value = aws_cloudfront_distribution.this.arn
}

output "alias_target_dns_name" {
  description = "Normalized alias target for dns/alias-record."
  value       = aws_cloudfront_distribution.this.domain_name
}

output "alias_target_zone_id" {
  description = "Normalized alias target zone id for dns/alias-record. Fixed AWS constant for all CloudFront distributions."
  value       = "Z2FDTNDATAQYW2"
}
