output "service_name" {
  description = "ECS service name."
  value       = aws_ecs_service.this.name
}

output "target_group_arn" {
  description = "ARN of this service's target group."
  value       = aws_lb_target_group.this.arn
}

output "security_group_id" {
  description = "Security group ID assigned to the service's tasks."
  value       = aws_security_group.service.id
}

output "task_role_arn" {
  description = "ARN of the task's IAM role, for attaching further runtime permissions."
  value       = aws_iam_role.task.arn
}

output "log_group_name" {
  description = "CloudWatch log group name."
  value       = aws_cloudwatch_log_group.this.name
}
