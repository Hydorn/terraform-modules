variable "name_prefix" {
  description = "Prefix used for resource names/tags, e.g. \"wow-tracker-dev-frontend\"."
  type        = string
}

variable "tags" {
  description = "Tags merged into the distribution."
  type        = map(string)
  default     = {}
}

variable "bucket_id" {
  description = "S3 bucket name (e.g. storage/s3-static-site module's bucket_id output)."
  type        = string
}

variable "bucket_arn" {
  description = "S3 bucket ARN (e.g. storage/s3-static-site module's bucket_arn output), used in the bucket policy this module creates."
  type        = string
}

variable "bucket_regional_domain_name" {
  description = "S3 bucket regional domain name (e.g. storage/s3-static-site module's bucket_regional_domain_name output)."
  type        = string
}

variable "aliases" {
  description = "CNAMEs for the distribution, e.g. [\"collectiontracker.wow.emanuelrv.dev\"]."
  type        = list(string)
}

variable "certificate_arn" {
  description = "ACM certificate ARN — must be in us-east-1 regardless of your primary region (a CloudFront requirement)."
  type        = string
}

variable "price_class" {
  description = "CloudFront price class."
  type        = string
  default     = "PriceClass_100"
}

variable "default_root_object" {
  type    = string
  default = "index.html"
}
