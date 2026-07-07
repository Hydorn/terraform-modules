output "certificate_arn" {
  description = <<-EOT
    ARN of the *validated* certificate (sourced from aws_acm_certificate_validation, not the raw
    aws_acm_certificate resource), so anything consuming this output implicitly waits for DNS
    validation to complete before it can be applied.
  EOT
  value       = aws_acm_certificate_validation.this.certificate_arn
}
