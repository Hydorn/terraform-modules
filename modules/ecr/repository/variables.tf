variable "name_prefix" {
  description = "Repository name, e.g. \"wow-tracker-backend\" (must be unique within the account+region)."
  type        = string
}

variable "tags" {
  description = "Tags merged into the repository."
  type        = map(string)
  default     = {}
}

variable "image_tag_mutability" {
  description = "MUTABLE or IMMUTABLE."
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Whether to scan images for vulnerabilities on push."
  type        = bool
  default     = true
}

variable "untagged_image_expiry_days" {
  description = "Expire untagged images after this many days."
  type        = number
  default     = 14
}

variable "tagged_image_tag_prefixes" {
  description = <<-EOT
    Tag prefixes (e.g. ["sha-"]) subject to the tagged-image retention rule below. Leave empty
    (default) to skip tagged-image expiry entirely and only expire untagged images.
  EOT
  type        = list(string)
  default     = []
}

variable "tagged_image_keep_count" {
  description = "Number of tagged images (matching tagged_image_tag_prefixes) to retain."
  type        = number
  default     = 10
}
