
locals {
  fqdn = "user-workspace.${var.modulecaller_dns_r53_hostedzone}"
}


data "aws_route53_zone" "hosted_zone" {
  provider = aws.route53_account

  name         = var.modulecaller_dns_r53_hostedzone
  private_zone = false
}


# generate ACM cert for domain :
resource "aws_acm_certificate" "cert" {
  domain_name       = local.fqdn
  validation_method = "DNS"

  tags = {
    Name = local.fqdn
  }

  options {
    certificate_transparency_logging_preference = "ENABLED"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags,
      tags_all
    ]
  }

}

# validate cert:
resource "aws_route53_record" "cert_validation" {
  provider = aws.route53_account

  for_each = {
    for d in aws_acm_certificate.cert.domain_validation_options : d.domain_name => {
      name   = d.resource_record_name
      record = d.resource_record_value
      type   = d.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.hosted_zone.zone_id

  depends_on = [aws_acm_certificate.cert]
}

resource "aws_acm_certificate_validation" "certvalidation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]

  depends_on = [aws_route53_record.cert_validation]
}


# creating A record for domain:
resource "aws_route53_record" "websiteurl" {
  provider = aws.route53_account

  name    = local.fqdn
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  type    = "A"

  alias {
    name                   = aws_alb.api_bluegreen.dns_name
    zone_id                = aws_alb.api_bluegreen.zone_id
    evaluate_target_health = true
  }
}
