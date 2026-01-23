output "db_instance_id" {
  description = "RDS instance ID"
  value       = aws_db_instance.this.id
}

output "db_instance_arn" {
  description = "RDS instance ARN"
  value       = aws_db_instance.this.arn
}

output "db_instance_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.this.endpoint
}

output "db_instance_address" {
  description = "RDS instance address"
  value       = aws_db_instance.this.address
}

output "db_instance_port" {
  description = "RDS instance port"
  value       = aws_db_instance.this.port
}

output "db_instance_name" {
  description = "Database name"
  value       = aws_db_instance.this.db_name
}

output "db_instance_username" {
  description = "Master username"
  value       = aws_db_instance.this.username
  sensitive   = true
}

output "security_group_id" {
  description = "ID of the RDS security group"
  value       = aws_security_group.rds.id
}

output "security_group_arn" {
  description = "ARN of the RDS security group"
  value       = aws_security_group.rds.arn
}
