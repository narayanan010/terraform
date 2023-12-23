
locals {
  domain_name    = "gdmlabs.dev"
  subdomain_name = "stormbreaker"
}

data "aws_route53_zone" "hosted_zone" {
  provider = aws.route53_account

  name         = local.domain_name
  private_zone = false
}


# generate ACM cert for domain :
resource "aws_acm_certificate" "cert" {
  domain_name       = "${local.subdomain_name}.${local.domain_name}"
  validation_method = "DNS"

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
resource "aws_route53_record" "certvalidation" {
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
}

resource "aws_acm_certificate_validation" "certvalidation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for r in aws_route53_record.certvalidation : r.fqdn]
}
