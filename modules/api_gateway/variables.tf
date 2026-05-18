variable "public_hosted_zone_name" {
  description = "Hosted zone name (e.g. example.com). Do not include a trailing dot or subdomain."
  type        = string
}

variable "api_subdomain" {
  description = "API subdomain (e.g. api). Do not include a trailing dot or full domain."
  type        = string
}

variable "additional_tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}