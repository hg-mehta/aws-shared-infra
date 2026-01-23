# Get standardized tags
module "tags" {
  source = "../../modules/tags"

  environment     = "dev"
  project         = "aws-shared-infra"
  additional_tags = {}
}

# Create DB subnet group
resource "aws_db_subnet_group" "dev" {
  name       = "dev-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(
    module.tags.tags,
    {
      Name = "dev-db-subnet-group"
    }
  )
}

# Create RDS instance
module "rds" {
  source = "../../modules/rds"

  environment            = "dev"
  db_name                = var.db_name
  db_instance_identifier = var.db_instance_identifier
  db_instance_class      = "db.t3.small"
  allocated_storage      = 20
  storage_type           = "gp2"

  engine         = "postgres"
  engine_version = "17.7"

  master_username = var.master_username
  master_password = var.master_password

  vpc_id = var.vpc_id
  port = var.port
  allowed_cidr_blocks = var.allowed_cidr_blocks
  db_subnet_group_name   = aws_db_subnet_group.dev.name

  publicly_accessible = true
  multi_az           = false

  backup_retention_period = 0
  skip_final_snapshot     = true

  enabled_cloudwatch_logs_exports = []
  performance_insights_enabled    = false
  monitoring_interval             = 0

  storage_encrypted   = true
  deletion_protection = false

  tags = module.tags.tags
}