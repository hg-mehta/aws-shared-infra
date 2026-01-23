resource "aws_security_group" "rds" {
  name        = "rds-${var.environment}-sg"
  description = "Security group for RDS ${var.environment} environment"
  vpc_id      = var.vpc_id

  ingress {
    description = "PostgreSQL access"
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "rds-${var.environment}-sg"
    }
  )
}

resource "aws_db_instance" "this" {
  identifier     = var.db_instance_identifier
  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.db_instance_class

  db_name  = var.db_name
  username = var.master_username
  password = var.master_password

  allocated_storage     = var.allocated_storage
  storage_type         = var.storage_type
  storage_encrypted    = var.storage_encrypted
  kms_key_id           = var.kms_key_id

  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = [aws_security_group.rds.id]

  publicly_accessible = var.publicly_accessible
  multi_az           = var.multi_az

  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  performance_insights_enabled    = var.performance_insights_enabled
  monitoring_interval             = var.monitoring_interval

  parameter_group_name = var.parameter_group_name
  deletion_protection  = var.deletion_protection

  tags = merge(
    var.tags,
    {
      Name = var.db_instance_identifier
    }
  )
}
