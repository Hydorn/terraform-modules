output "bucket_id" {
  value = aws_s3_bucket.this.id
}

output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}

output "bucket_regional_domain_name" {
  description = "Regional domain name (<bucket>.s3.<region>.amazonaws.com form), for cdn/cloudfront-spa's origin — not the S3 website-hosting endpoint form, since this bucket is fronted by CloudFront via OAC, not S3 website hosting."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}
