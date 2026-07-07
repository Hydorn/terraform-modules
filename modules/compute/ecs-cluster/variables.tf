variable "name_prefix" {
  description = "Cluster name, e.g. \"wow-tracker-dev\"."
  type        = string
}

variable "tags" {
  description = "Tags merged into the cluster."
  type        = map(string)
  default     = {}
}

variable "enable_container_insights" {
  description = "Enable CloudWatch Container Insights (adds cost)."
  type        = bool
  default     = false
}

variable "enable_fargate_spot" {
  description = "Make FARGATE_SPOT available as a capacity provider (services still default to on-demand FARGATE unless they opt in)."
  type        = bool
  default     = true
}
