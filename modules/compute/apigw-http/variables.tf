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

variable "lambda_invoke_arn" {
  description = "Invoke ARN of the target Lambda (e.g. compute/lambda-api module's invoke_arn output)."
  type        = string
}

variable "lambda_function_name" {
  description = "Function name of the target Lambda, for the invoke permission (e.g. compute/lambda-api module's function_name output)."
  type        = string
}

variable "domain_name" {
  description = "Custom domain for the API, e.g. \"api.collectiontracker.wow.emanuelrv.dev\"."
  type        = string
}

variable "certificate_arn" {
  description = "ACM certificate ARN for the custom domain, in the same region as this API Gateway (e.g. acm/certificate module's certificate_arn output)."
  type        = string
}
