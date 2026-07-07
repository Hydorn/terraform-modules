output "https_listener_arn" {
  description = "ARN of the HTTPS listener, for compute/ecs-service to attach a target group + rule to."
  value       = aws_lb_listener.https.arn
}

output "http_listener_arn" {
  description = "ARN of the HTTP listener (redirects to HTTPS)."
  value       = aws_lb_listener.http.arn
}

output "security_group_id" {
  description = "ALB security group ID, for compute/ecs-service to allow ingress from."
  value       = aws_security_group.alb.id
}

output "alias_target_dns_name" {
  description = "Normalized alias target for dns/alias-record (ALB's own dns_name)."
  value       = aws_lb.this.dns_name
}

output "alias_target_zone_id" {
  description = "Normalized alias target zone id for dns/alias-record (ALB's own zone_id)."
  value       = aws_lb.this.zone_id
}
