output "alb_arn" {
  description = "ALB ARN"
  value       = aws_lb.main.arn
}

output "alb_id" {
  description = "ALB ID"
  value       = aws_lb.main.id
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "ALB zone ID"
  value       = aws_lb.main.zone_id
}

output "alb_security_group_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb.id
}

output "alb_security_group_arn" {
  description = "ALB security group ARN"
  value       = aws_security_group.alb.arn
}

output "alb_http_listener_arn" {
  description = "ALB HTTP listener ARN"
  value       = aws_lb_listener.http_redirect.arn
}

output "alb_https_listener_arn" {
  description = "ALB HTTPS listener ARN"
  value       = aws_lb_listener.https.arn
}