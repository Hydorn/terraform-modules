output "function_name" {
  value = aws_lambda_function.this.function_name
}

output "function_arn" {
  value = aws_lambda_function.this.arn
}

output "invoke_arn" {
  description = "Invoke ARN, for compute/apigw-http's Lambda integration."
  value       = aws_lambda_function.this.invoke_arn
}

output "role_arn" {
  value = aws_iam_role.this.arn
}
