terraform {
  backend "s3" {
    bucket         = "hgmehta-shared-infra-state-us-east-1"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
