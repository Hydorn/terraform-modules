variable "name_prefix" {
  description = "Bucket name, e.g. \"wow-tracker-dev-frontend\" (must be globally unique)."
  type        = string
}

variable "tags" {
  description = "Tags merged into the bucket."
  type        = map(string)
  default     = {}
}

variable "versioning_enabled" {
  type    = bool
  default = true
}

variable "force_destroy" {
  description = "Allow destroying the bucket even if it still contains objects. Handy for throwaway dev environments."
  type        = bool
  default     = false
}
