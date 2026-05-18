output "shared_infra_tags" {
  description = "Standardized tags for resources"
  value = merge(
    {
      Environment = var.environment
      Project     = var.project
      ManagedBy   = "Terraform"
      CreatedAt   = timestamp()
    },
    var.additional_tags
  )
}
