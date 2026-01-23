# AWS Shared Infrastructure

This repository contains Terraform modules and configurations for managing shared AWS infrastructure across different projects. It supports multiple environments (dev, prod) and is deployed via GitHub Actions CI/CD.

## Architecture

- **Modules**: Reusable Terraform modules for AWS resources
- **Environments**: Environment-specific configurations (dev, prod)
- **CI/CD**: GitHub Actions workflows for automated deployment
- **State Management**: Terraform state stored in S3 with DynamoDB locking

## Prerequisites

1. AWS Account with appropriate permissions
2. S3 bucket for Terraform state (create manually or via bootstrap script)
3. DynamoDB table for state locking (create manually or via bootstrap script)
4. GitHub Secrets configured (see `.github/workflows/terraform-setup.md` for details):
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `TF_VAR_MASTER_USERNAME` (for RDS)
   - `TF_VAR_MASTER_PASSWORD` (for RDS)
   - `TF_VAR_VPC_ID` (VPC ID for your environment)
   - `TF_VAR_SUBNET_IDS` (JSON array format: `["subnet-xxx", "subnet-yyy"]`)

## Repository Structure

```
.
├── modules/
│   ├── rds/              # RDS module
│   ├── security-groups/  # Security groups module
│   └── tags/             # Standardized tags module
├── environments/
│   ├── dev/              # Development environment
│   └── prod/             # Production environment (to be created)
├── .github/
│   └── workflows/
│       └── terraform.yml # CI/CD workflow
├── backend.tf            # Terraform backend configuration
├── provider.tf            # AWS provider configuration
└── versions.tf           # Terraform version requirements
```

## Setup

### 1. Create S3 Backend and DynamoDB Table

Before running Terraform, you need to create the S3 bucket and DynamoDB table for state management:

```bash
# Create S3 bucket
aws s3api create-bucket \
  --bucket aws-shared-infra-terraform-state \
  --region us-east-1

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket aws-shared-infra-terraform-state \
  --versioning-configuration Status=Enabled

# Enable encryption
aws s3api put-bucket-encryption \
  --bucket aws-shared-infra-terraform-state \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'

# Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

### 2. Configure Environment Variables

For each environment, create a `terraform.tfvars` file based on the example:

```bash
cd environments/dev
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

Required variables:
- `vpc_id`: Your VPC ID
- `subnet_ids`: List of subnet IDs for the DB subnet group
- `master_username`: Database master username
- `master_password`: Database master password

### 3. GitHub Secrets Configuration

Configure the following secrets in your GitHub repository:

1. Go to Settings → Secrets and variables → Actions
2. Add the following secrets:
   - `AWS_ACCESS_KEY_ID`: AWS access key
   - `AWS_SECRET_ACCESS_KEY`: AWS secret key
   - `TF_VAR_MASTER_USERNAME`: RDS master username
   - `TF_VAR_MASTER_PASSWORD`: RDS master password

## Usage

### Local Development

```bash
# Navigate to environment
cd environments/dev

# Initialize Terraform
terraform init

# Plan changes
terraform plan

# Apply changes
terraform apply
```

### CI/CD Deployment

The GitHub Actions workflow automatically:
- Validates Terraform configuration on pull requests
- Plans changes on pull requests
- Applies changes when merged to main branch
- Supports manual workflow dispatch for specific environments

#### Manual Workflow Dispatch

1. Go to Actions → Terraform CI/CD
2. Click "Run workflow"
3. Select:
   - Environment: dev or prod
   - Action: plan, apply, or destroy

## Modules

### RDS Module

Configurable RDS module supporting:
- PostgreSQL and other engines
- Configurable instance class, storage, and engine version
- Public/private access
- Multi-AZ or Single-AZ deployment
- Backup configuration
- Performance Insights (optional)
- CloudWatch logs (optional)

**Example Usage:**
```hcl
module "rds" {
  source = "../../modules/rds"

  environment            = "dev"
  db_name                = "mydb"
  db_instance_identifier = "my-postgres-instance"
  db_instance_class      = "db.t3.small"
  allocated_storage      = 50
  storage_type           = "gp2"

  master_username = "admin"
  master_password = "securepassword"

  vpc_security_group_ids = [module.security_group.security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  publicly_accessible = true
  multi_az           = false

  tags = module.tags.tags
}
```

### Security Groups Module

Creates security groups for RDS with configurable:
- Ingress rules
- CIDR blocks
- Port configuration

### Tags Module

Provides standardized tagging across all resources:
- Environment
- Project
- ManagedBy (Terraform)
- CreatedAt timestamp
- Additional custom tags

## Development Environment

The dev environment is configured with:
- PostgreSQL 15.4
- db.t3.small instance
- 20GB gp2 storage
- Single AZ deployment
- Public access enabled
- No automated backups
- No Performance Insights
- No CloudWatch logs

## Production Environment

To create a production environment:
1. Copy the dev environment structure
2. Adjust variables for production requirements
3. Enable additional features as needed (backups, monitoring, etc.)

## Reserved Instances

**Note**: Terraform does not directly manage AWS Reserved Instances. To purchase reserved instances:

1. After deploying the RDS instance, go to AWS Console → EC2 → Reserved Instances
2. Purchase a reserved instance matching your configuration:
   - Instance type: db.t3.small
   - Term: 1 year
   - Payment option: No Upfront
   - Offering class: Standard

Alternatively, you can use AWS CLI:
```bash
aws ec2 describe-reserved-instances-offerings \
  --instance-type db.t3.small \
  --product-description "PostgreSQL" \
  --offering-type "No Upfront" \
  --max-duration 31536000
```

## Security Considerations

1. **Secrets Management**: Use AWS Secrets Manager or Parameter Store for production
2. **Network Security**: Restrict `allowed_cidr_blocks` to specific IP ranges
3. **Encryption**: RDS storage encryption is enabled by default
4. **Access Control**: Use IAM roles and policies to restrict access
5. **State File**: Ensure S3 bucket has proper access controls

## Contributing

1. Create a feature branch
2. Make your changes
3. Submit a pull request
4. Ensure Terraform validation passes
