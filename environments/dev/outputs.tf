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
  value       = module.rds_security_group.security_group_id
}
