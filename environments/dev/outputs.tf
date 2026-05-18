output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = module.rds.db_instance_endpoint
}

output "rds_address" {
  description = "RDS instance address"
  value       = module.rds.db_instance_address
}

output "rds_port" {
  description = "RDS instance port"
  value       = module.rds.db_instance_port
}

output "rds_database_name" {
  description = "Database name"
  value       = module.rds.db_instance_name
}

output "security_group_id" {
  description = "RDS security group ID"
  value       = module.rds.security_group_id
}

output "api_domain_name" {
  description = "API domain name"
  value       = module.api_gateway.api_domain_name
}

output "api_domain_id" {
  description = "API domain ID"
  value       = module.api_gateway.api_domain_id
}

output "api_domain_arn" {
  description = "API domain ARN"
  value       = module.api_gateway.api_domain_arn
}

output "alb_arn" {
  description = "ALB ARN"
  value       = try(module.alb["enabled"].alb_arn, null)
}

output "alb_id" {
  description = "ALB ID"
  value       = try(module.alb["enabled"].alb_id, null)
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = try(module.alb["enabled"].alb_dns_name, null)
}

output "alb_zone_id" {
  description = "ALB zone ID"
  value       = try(module.alb["enabled"].alb_zone_id, null)
}

output "alb_security_group_id" {
  description = "ALB security group ID"
  value       = try(module.alb["enabled"].alb_security_group_id, null)
}

output "alb_security_group_arn" {
  description = "ALB security group ARN"
  value       = try(module.alb["enabled"].alb_security_group_arn, null)
}

output "alb_http_listener_arn" {
  description = "ALB HTTP listener ARN"
  value       = try(module.alb["enabled"].alb_http_listener_arn, null)
}

output "alb_https_listener_arn" {
  description = "ALB HTTPS listener ARN"
  value       = try(module.alb["enabled"].alb_https_listener_arn, null)
}