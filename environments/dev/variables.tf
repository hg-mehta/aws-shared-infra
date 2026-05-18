variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "port" {
  description = "RDS port"
  type        = number
  default     = 5432
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access RDS"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "vpc_id" {
  description = "VPC ID where resources will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for DB subnet group (at least 2 for best practices, but single AZ will use one)"
  type        = list(string)
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "devdb"
}

variable "db_instance_identifier" {
  description = "RDS instance identifier"
  type        = string
  default     = "dev-postgresql-instance"
}

variable "master_username" {
  description = "Master username for the database"
  type        = string
  sensitive   = true
}

variable "master_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

variable "public_hosted_zone_name" {
  description = "Hosted zone name (e.g. example.com). Do not include a trailing dot or subdomain."
  type        = string
}

variable "api_subdomain" {
  description = "API subdomain (e.g. api). Do not include a trailing dot or full domain."
  type        = string
}

variable "enable_alb" {
  description = "Enable ALB"
  type        = bool
}