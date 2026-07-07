variable "name_prefix" {
  description = "Prefix used for resource names/tags, e.g. \"wow-tracker-dev\"."
  type        = string
}

variable "app_name" {
  description = "Application name, e.g. \"backend\"."
  type        = string
}

variable "tags" {
  description = "Tags merged into every resource."
  type        = map(string)
  default     = {}
}

variable "package_type" {
  description = "\"Zip\" (default, recommended for small Node functions — faster cold start) or \"Image\" (container image via the ecr/repository module)."
  type        = string
  default     = "Zip"

  validation {
    condition     = contains(["Zip", "Image"], var.package_type)
    error_message = "package_type must be \"Zip\" or \"Image\"."
  }
}

variable "filename" {
  description = "Path to a local deployment zip. Required when package_type = \"Zip\" and not using an S3-hosted package."
  type        = string
  default     = null
}

variable "s3_bucket" {
  description = "S3 bucket holding the deployment zip. Alternative to filename when package_type = \"Zip\"."
  type        = string
  default     = null
}

variable "s3_key" {
  description = "S3 key of the deployment zip. Used with s3_bucket."
  type        = string
  default     = null
}

variable "s3_object_version" {
  type    = string
  default = null
}

variable "image_uri" {
  description = "Container image URI (e.g. \"<ecr repository_url>:<tag>\"). Required when package_type = \"Image\"."
  type        = string
  default     = null
}

variable "handler" {
  description = "Lambda handler, e.g. \"dist/lambda.handler\". Required when package_type = \"Zip\"."
  type        = string
  default     = "index.handler"
}

variable "runtime" {
  description = "Lambda runtime. Required when package_type = \"Zip\"."
  type        = string
  default     = "nodejs20.x"
}

variable "memory_size" {
  type    = number
  default = 512
}

variable "timeout" {
  description = <<-EOT
    Lambda function timeout in seconds. Note: if this function sits behind compute/apigw-http,
    API Gateway's own integration timeout is hard-capped at 30 seconds regardless of this value
    — a higher timeout here only helps for non-API-Gateway invocations (e.g. async/event
    triggers you add later).
  EOT
  type        = number
  default     = 30
}

variable "environment" {
  description = "Environment variables for the function."
  type        = map(string)
  default     = {}
}

variable "secrets_manager_arns" {
  description = "Secrets Manager ARNs the function's role should be allowed to GetSecretValue on. The function itself must call the Secrets Manager SDK at runtime — Lambda has no native secrets-injection like ECS task definitions do."
  type        = list(string)
  default     = []
}

variable "role_policy_arns" {
  description = "Additional IAM policy ARNs to attach to the function's role."
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "Subnet IDs to run the function in a VPC. Leave empty (default) to run outside a VPC — faster cold starts, and fine for a function that only calls external HTTP APIs and AWS APIs, not VPC-only resources like RDS."
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "Security group IDs, used only when subnet_ids is non-empty."
  type        = list(string)
  default     = []
}

variable "log_retention_in_days" {
  type    = number
  default = 14
}
