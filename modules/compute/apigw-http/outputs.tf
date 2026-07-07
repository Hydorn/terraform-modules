output "api_id" {
  value = aws_apigatewayv2_api.this.id
}

output "invoke_url" {
  description = "Default execute-api invoke URL (before the custom domain)."
  value       = aws_apigatewayv2_stage.default.invoke_url
}

output "alias_target_dns_name" {
  description = "Normalized alias target for dns/alias-record."
  value       = aws_apigatewayv2_domain_name.this.domain_name_configuration[0].target_domain_name
}

output "alias_target_zone_id" {
  description = "Normalized alias target zone id for dns/alias-record."
  value       = aws_apigatewayv2_domain_name.this.domain_name_configuration[0].hosted_zone_id
}
