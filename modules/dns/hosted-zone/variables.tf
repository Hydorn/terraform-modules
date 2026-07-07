variable "domain_name" {
  description = "Domain name for the hosted zone, e.g. \"wow.emanuelrv.dev\"."
  type        = string
}

variable "create_zone" {
  description = <<-EOT
    Whether to create a new public hosted zone (true, default) or look up an existing one by
    name (false). Use false for reuse in projects where the zone already exists and shouldn't
    be recreated.
  EOT
  type        = bool
  default     = true
}

variable "comment" {
  description = "Comment set on the hosted zone when created."
  type        = string
  default     = "Managed by Terraform"
}

variable "tags" {
  description = "Tags merged into the hosted zone (only applies when create_zone = true)."
  type        = map(string)
  default     = {}
}
