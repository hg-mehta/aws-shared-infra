variable "environment" {
  description = "Environment name (dev, prod, etc.)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where security group will be created"
  type        = string
}

variable "port" {
  description = "RDS port"
  type        = number
  default     = 5432
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access RDS"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}


variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "db_instance_identifier" {
  description = "RDS instance identifier"
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class (e.g., db.t3.small)"
  type        = string
  default     = "db.t3.small"
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 50
}

variable "storage_type" {
  description = "Storage type (gp2, gp3, io1, etc.)"
  type        = string
  default     = "gp2"
}

variable "engine" {
  description = "Database engine"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "15.4"
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

variable "db_subnet_group_name" {
  description = "DB subnet group name"
  type        = string
}

variable "publicly_accessible" {
  description = "Whether the RDS instance is publicly accessible"
  type        = bool
  default     = true
}

variable "multi_az" {
  description = "Whether to deploy in multiple AZs"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Backup retention period in days (0 to disable)"
  type        = number
  default     = 0
}

variable "skip_final_snapshot" {
  description = "Whether to skip final snapshot on deletion"
  type        = bool
  default     = true
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to CloudWatch"
  type        = list(string)
  default     = []
}

variable "performance_insights_enabled" {
  description = "Whether to enable Performance Insights"
  type        = bool
  default     = false
}

variable "monitoring_interval" {
  description = "Monitoring interval in seconds (0, 60, 300)"
  type        = number
  default     = 0
}

variable "tags" {
  description = "Tags to apply to RDS instance"
  type        = map(string)
  default     = {}
}

variable "parameter_group_name" {
  description = "Name of the DB parameter group to associate"
  type        = string
  default     = null
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "storage_encrypted" {
  description = "Enable storage encryption"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "KMS key ID for encryption (uses default if not specified)"
  type        = string
  default     = null
}
