variable "name_prefix" {
  description = "Prefix used for resource names/tags, e.g. \"wow-tracker-dev\"."
  type        = string
}

variable "table_name_suffix" {
  description = "Suffix appended to name_prefix to form the table name, e.g. \"catalog\" -> \"wow-tracker-dev-catalog\"."
  type        = string
}

variable "tags" {
  description = "Tags merged into the table."
  type        = map(string)
  default     = {}
}

variable "hash_key" {
  description = "Partition key attribute name, e.g. \"PK\"."
  type        = string
}

variable "hash_key_type" {
  description = "Partition key attribute type (S, N, or B)."
  type        = string
  default     = "S"
}

variable "range_key" {
  description = "Sort key attribute name, e.g. \"SK\". Omit (null) for a table with no sort key."
  type        = string
  default     = null
}

variable "range_key_type" {
  description = "Sort key attribute type (S, N, or B). Only used when range_key is set."
  type        = string
  default     = "S"
}

variable "billing_mode" {
  description = "\"PAY_PER_REQUEST\" (default) or \"PROVISIONED\"."
  type        = string
  default     = "PAY_PER_REQUEST"

  validation {
    condition     = contains(["PAY_PER_REQUEST", "PROVISIONED"], var.billing_mode)
    error_message = "billing_mode must be \"PAY_PER_REQUEST\" or \"PROVISIONED\"."
  }
}

variable "read_capacity" {
  description = "Provisioned read capacity units. Required when billing_mode = \"PROVISIONED\", ignored otherwise."
  type        = number
  default     = null
}

variable "write_capacity" {
  description = "Provisioned write capacity units. Required when billing_mode = \"PROVISIONED\", ignored otherwise."
  type        = number
  default     = null
}

variable "point_in_time_recovery_enabled" {
  description = "Whether to enable point-in-time recovery."
  type        = bool
  default     = true
}
