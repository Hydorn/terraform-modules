variable "name_prefix" {
  description = "Prefix used for resource names/tags, e.g. \"wow-tracker-dev\"."
  type        = string
}

variable "app_name" {
  description = "Application name, e.g. \"backend\". Combined with name_prefix for the task family, log group, and container name."
  type        = string
}

variable "tags" {
  description = "Tags merged into every resource."
  type        = map(string)
  default     = {}
}

variable "cluster_id" {
  description = "ECS cluster ID (e.g. compute/ecs-cluster module's cluster_id output)."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID (e.g. networking/vpc module's vpc_id output)."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the service's tasks. Use public subnets with assign_public_ip = true (default) unless the VPC's NAT gateway is enabled, in which case pass private subnets and set assign_public_ip = false."
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Whether tasks get a public IP. See the note on subnet_ids above."
  type        = bool
  default     = true
}

variable "alb_security_group_id" {
  description = "Security group ID of the ALB (e.g. compute/alb module's security_group_id output) — the service's security group only allows ingress from this."
  type        = string
}

variable "https_listener_arn" {
  description = "ARN of the ALB's HTTPS listener to attach this service's target group/rule to (e.g. compute/alb module's https_listener_arn output)."
  type        = string
}

variable "listener_rule_priority" {
  description = "Priority for this service's listener rule (must be unique per listener across all services attached to the same ALB)."
  type        = number
}

variable "host_headers" {
  description = "Host-header values routed to this service (e.g. [\"api.collectiontracker.wow.emanuelrv.dev\"]). Leave empty to instead match on a catch-all path_pattern of \"/*\" (only sensible if this is the only service on the ALB)."
  type        = list(string)
  default     = []
}

variable "container_image" {
  description = "Full image reference, e.g. \"<ecr repository_url>:<tag>\"."
  type        = string
}

variable "container_port" {
  description = "Port the container listens on (matches the app's PORT env var)."
  type        = number
  default     = 3000
}

variable "cpu" {
  description = "Fargate task CPU units."
  type        = number
  default     = 256
}

variable "memory" {
  description = "Fargate task memory (MiB)."
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Number of tasks to run."
  type        = number
  default     = 1
}

variable "environment" {
  description = "Plain (non-secret) environment variables for the container."
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "Secret environment variables for the container: map of env var name to a Secrets Manager or SSM Parameter Store ARN."
  type        = map(string)
  default     = {}
}

variable "task_role_policy_arns" {
  description = "Additional IAM policy ARNs to attach to the task role (the app's own runtime AWS permissions). Empty by default — this app has none."
  type        = list(string)
  default     = []
}

variable "log_retention_in_days" {
  description = "CloudWatch log group retention."
  type        = number
  default     = 14
}

variable "health_check_path" {
  description = <<-EOT
    Path for the ALB target group health check. Point this at a lightweight endpoint that
    returns 200 immediately without touching any slow first-request logic (e.g. a cache
    rebuild) — otherwise health checks fail and ECS cycles the task after every deploy.
  EOT
  type        = string
  default     = "/api/health"
}

variable "health_check_interval" {
  type    = number
  default = 30
}

variable "health_check_timeout" {
  type    = number
  default = 5
}

variable "health_check_healthy_threshold" {
  type    = number
  default = 2
}

variable "health_check_unhealthy_threshold" {
  type    = number
  default = 3
}

variable "health_check_grace_period_seconds" {
  description = "Grace period during which failing ALB health checks don't cause ECS to replace a starting task. Should comfortably cover the app's real startup time."
  type        = number
  default     = 60
}

variable "deployment_minimum_healthy_percent" {
  type    = number
  default = 100
}

variable "deployment_maximum_percent" {
  type    = number
  default = 200
}
