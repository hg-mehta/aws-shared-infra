variable "environment" {
  description = "Environment name (dev, prod, etc.)"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "aws-shared-infra"
}

variable "additional_tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}
