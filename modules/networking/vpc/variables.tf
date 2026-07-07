variable "name_prefix" {
  description = "Prefix used for resource names/tags, e.g. \"wow-tracker-dev\"."
  type        = string
}

variable "tags" {
  description = "Tags merged into every resource."
  type        = map(string)
  default     = {}
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_count" {
  description = "Number of availability zones to spread public (and, if enabled, private) subnets across."
  type        = number
  default     = 2
}

variable "enable_nat_gateway" {
  description = <<-EOT
    Whether to create private subnets + a single NAT gateway for outbound-only internet access.
    Defaults to false: workloads run in public subnets with a public IP instead, which is
    cheaper (no NAT gateway hourly + data processing cost) and fine for stateless workloads
    with no inbound access other than through a load balancer's security group. Set to true
    for workloads that must not have a public IP.
  EOT
  type        = bool
  default     = false
}
