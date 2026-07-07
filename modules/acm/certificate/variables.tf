variable "domain_name" {
  description = "Primary domain name for the certificate, e.g. \"collectiontracker.wow.emanuelrv.dev\"."
  type        = string
}

variable "subject_alternative_names" {
  description = "Additional domain names to cover with this certificate."
  type        = list(string)
  default     = []
}

variable "zone_id" {
  description = "Hosted zone ID to create DNS validation records in (e.g. dns/hosted-zone module's zone_id output)."
  type        = string
}

variable "tags" {
  description = "Tags merged into the certificate."
  type        = map(string)
  default     = {}
}
