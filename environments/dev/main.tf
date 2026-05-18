terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.28"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.7"
    }
  }

  backend "s3" {
    bucket         = "hgmehta-shared-infra-state-us-east-1"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "aws-shared-infra"
      ManagedBy   = "terraform"
      Environment = "dev"
    }
  }
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
  default_tags {
    tags = {
      Project     = "aws-shared-infra"
      ManagedBy   = "terraform"
      Environment = "dev"
    }
  }
}

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
    module.tags.shared_infra_tags,
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

  vpc_id               = var.vpc_id
  port                 = var.port
  allowed_cidr_blocks  = var.allowed_cidr_blocks
  db_subnet_group_name = aws_db_subnet_group.dev.name

  publicly_accessible = true
  multi_az            = false

  backup_retention_period = 0
  skip_final_snapshot     = true

  enabled_cloudwatch_logs_exports = []
  performance_insights_enabled    = false
  monitoring_interval             = 0

  storage_encrypted   = true
  deletion_protection = false

  tags = module.tags.shared_infra_tags
}

module "api_gateway" {
  source = "../../modules/api_gateway"

  public_hosted_zone_name = var.public_hosted_zone_name
  api_subdomain           = var.api_subdomain
  additional_tags         = module.tags.shared_infra_tags
}

module "alb" {
  source   = "../../modules/alb"
  for_each = var.enable_alb ? { enabled = true } : {}

  alb_name              = "shared-infra-alb"
  alb_public_subnet_ids = var.subnet_ids
  tags                  = module.tags.shared_infra_tags
  allowed_cidr_blocks   = var.allowed_cidr_blocks
  vpc_id                = var.vpc_id
  certificate_arn       = module.api_gateway.api_domain_certificate_arn
}
