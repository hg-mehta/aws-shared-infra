data "aws_route53_zone" "selected" {
  name         = var.public_hosted_zone_name
  private_zone = false
}

# ACM Certificate for API Gateway custom domain (if api_subdomain is set)
resource "aws_acm_certificate" "api_domain" {
  count             = data.aws_route53_zone.selected.name != "" ? 1 : 0
  domain_name       = "${var.api_subdomain}.${data.aws_route53_zone.selected.name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.additional_tags,
    {
      Description = "API Gateway Certificate for ${var.api_subdomain}.${data.aws_route53_zone.selected.name}"
    }
  )
}

# Route53 validation record for API domain certificate
resource "aws_route53_record" "api_cert_validation" {
  for_each = data.aws_route53_zone.selected.name != "" ? {
    for dvo in aws_acm_certificate.api_domain[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.selected.zone_id

  depends_on = [aws_acm_certificate.api_domain]
}

# Certificate validation for API domain
resource "aws_acm_certificate_validation" "api_domain" {
  count           = data.aws_route53_zone.selected.name != "" ? 1 : 0
  certificate_arn = aws_acm_certificate.api_domain[0].arn
  validation_record_fqdns = [
    for record in aws_route53_record.api_cert_validation : record.fqdn
  ]

  timeouts {
    create = "5m"
  }
}

# API Gateway Custom Domain
resource "aws_apigatewayv2_domain_name" "api" {
  count       = data.aws_route53_zone.selected.name != "" ? 1 : 0
  domain_name = "${var.api_subdomain}.${data.aws_route53_zone.selected.name}"

  domain_name_configuration {
    certificate_arn = aws_acm_certificate_validation.api_domain[0].certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  depends_on = [aws_acm_certificate_validation.api_domain]
  tags = merge(
    var.additional_tags,
    {
      Description = "API Gateway Custom Domain for ${var.api_subdomain}.${data.aws_route53_zone.selected.name}"
    }
  )
}

# Route53 A record for API Gateway custom domain
resource "aws_route53_record" "api_a" {
  count   = data.aws_route53_zone.selected.name != "" ? 1 : 0
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${var.api_subdomain}.${data.aws_route53_zone.selected.name}"
  type    = "A"

  alias {
    name                   = aws_apigatewayv2_domain_name.api[0].domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.api[0].domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}
