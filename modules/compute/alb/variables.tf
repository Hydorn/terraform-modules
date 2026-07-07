variable "name_prefix" {
  description = "ALB name, e.g. \"wow-tracker-dev\" (keep to 32 characters or fewer — an AWS ALB naming limit)."
  type        = string
}

variable "tags" {
  description = "Tags merged into every resource."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID (e.g. networking/vpc module's vpc_id output)."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the ALB (public subnets for an internet-facing ALB)."
  type        = list(string)
}

variable "certificate_arn" {
  description = "ACM certificate ARN for the HTTPS listener (e.g. acm/certificate module's certificate_arn output)."
  type        = string
}

variable "internal" {
  description = "Whether the ALB is internal (no public IP) rather than internet-facing."
  type        = bool
  default     = false
}

variable "ssl_policy" {
  description = "ALB SSL negotiation policy."
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "idle_timeout" {
  description = "Idle timeout in seconds."
  type        = number
  default     = 60
}

variable "enable_deletion_protection" {
  description = "Whether to enable deletion protection on the ALB."
  type        = bool
  default     = false
}
