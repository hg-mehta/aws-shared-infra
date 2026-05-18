output "api_domain_id" {
  value       = try(aws_apigatewayv2_domain_name.api[0].id, "")
  description = "The ID of the API Gateway v2 domain name"
}

output "api_domain_name" {
  description = "API domain name"
  value       = aws_apigatewayv2_domain_name.api[0].domain_name
}

output "api_domain_arn" {
  description = "API domain ARN"
  value       = aws_apigatewayv2_domain_name.api[0].arn
}

output "api_domain_certificate_arn" {
  description = "API domain certificate ARN"
  value       = aws_apigatewayv2_domain_name.api[0].domain_name_configuration[0].certificate_arn
}