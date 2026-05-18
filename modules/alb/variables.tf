variable "alb_name" {
  description = "ALB name"
  type        = string
}

variable "alb_public_subnet_ids" {
  description = "ALB public subnet IDs"
  type        = list(string)
}

variable "tags" {
  description = "ALB tags"
  type        = map(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "Allowed CIDR blocks"
  type        = list(string)
}

variable "certificate_arn" {
  description = "Certificate ARN"
  type        = string
}