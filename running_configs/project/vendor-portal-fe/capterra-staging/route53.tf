locals {
  fqdn = "digitalmarkets-new.${var.modulecaller_dns_r53_hostedzone}"
}

data "aws_route53_zone" "hosted_zone" {
  name         = var.modulecaller_dns_r53_hostedzone
  private_zone = false
}

# creating A record 
resource "aws_route53_record" "vendor_portal_fe01" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = local.fqdn
  type    = "A"

  alias {
    name                   = "k8s-vendorpo-stgvpfei-ce8fe386bb-673537149.us-east-1.elb.amazonaws.com" # hardcoded from Helm ALB
    zone_id                = "Z35SXDOTRQ7X7K"                                                         # hardcoded from Helm ALB
    evaluate_target_health = true
  }
}
