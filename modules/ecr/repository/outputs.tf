output "repository_url" {
  description = "Repository URL, used as the base for image tags pushed by CI and referenced by compute/ecs-service or compute/lambda-api."
  value       = aws_ecr_repository.this.repository_url
}

output "repository_arn" {
  description = "ARN of the repository."
  value       = aws_ecr_repository.this.arn
}

output "repository_name" {
  description = "Name of the repository."
  value       = aws_ecr_repository.this.name
}
