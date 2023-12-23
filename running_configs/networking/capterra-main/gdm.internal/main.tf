module "dns-zones" {
  source = "git::ssh://git@github.com/capterra/terraform.git//modules/networking/route-53/zones"
  zones = {
    "gdm_internal" = {
      domain_name         = "gdm.internal"
      comment             = "${var.vpc_id[0]} and ${var.vpc_id[1]} - association for private DNS for gdm internal"
      delegation_set_id   = null
      vpc                 = {
        "main-prod" = {
          id                  = var.vpc_id[0]
          region              = var.vpc_region[0]
        },
        "main-dr"   = {
          id                  = var.vpc_id[1]
          region              = var.vpc_region[1]
        }
      }
      force_destroy       = false
    }
  }
}

resource "aws_route53_record" "gdm-bids-global-prod" {
  zone_id = module.dns-zones.route53_zone_zone_id.gdm_internal
  name    = "gdm-bids-global-prod"
  type    = "CNAME"
  ttl     = 60
  records = var.record_dns_value_gdm-bids-global-prod
}

resource "aws_route53_record" "gdm-bxapi-global-prod" {
  zone_id = module.dns-zones.route53_zone_zone_id.gdm_internal
  name    = "gdm-bxapi-global-prod"
  type    = "CNAME"
  ttl     = 60
  records = var.record_dns_value_gdm-bxapi-global-prod
}

resource "aws_route53_record" "gdm-bxapi-global-prod-dr" {
  zone_id = module.dns-zones.route53_zone_zone_id.gdm_internal
  name    = "gdm-bxapi-global-prod-dr"
  type    = "CNAME"
  ttl     = 60
  records = var.record_dns_value_gdm-bxapi-global-prod-dr
}

resource "aws_route53_record" "gdm-vxautobidder-global-prod" {
  zone_id = module.dns-zones.route53_zone_zone_id.gdm_internal
  name    = "gdm-vxautobidder-global-prod"
  type    = "CNAME"
  ttl     = 60
  records = var.record_dns_value_gdm-vxautobidder-global-prod
}

resource "aws_route53_record" "gdm-vxautobidder-global-prod-dr" {
  zone_id = module.dns-zones.route53_zone_zone_id.gdm_internal
  name    = "gdm-vxautobidder-global-prod-dr"
  type    = "CNAME"
  ttl     = 60
  records = var.record_dns_value_gdm-gdm-vxautobidder-global-prod-dr
}

resource "aws_route53_record" "gdm-vxautobidder-global-prod-dr-ro" {
  zone_id = module.dns-zones.route53_zone_zone_id.gdm_internal
  name    = "gdm-vxautobidder-global-prod-dr-ro"
  type    = "CNAME"
  ttl     = 60
  records = var.record_dns_value_gdm-gdm-vxautobidder-global-prod-dr-ro
}

resource "aws_route53_record" "gdm-bxapi-global-prod-ro" {
  zone_id = module.dns-zones.route53_zone_zone_id.gdm_internal
  name    = "gdm-bxapi-global-prod-ro"
  type    = "CNAME"
  ttl     = 60
  records = var.record_dns_value_gdm-gdm-bxapi-global-prod-ro
}

module "tags_resource_module" {
  source = "git::ssh://git@github.com/capterra/terraform.git//modules/tagging-resource-module"

  application       = "r53"
  app_component     = "network"
  function          = "internal"
  business_unit     = "gdm"
  app_contacts      = "capterra_devops"
  created_by        = "sarvesh.gupta@gartner.com"
  system_risk_class = "3"
  region            = var.modulecaller_source_region
  monitoring        = "false"
  terraform_managed = "true"
  vertical          = var.vertical
  environment       = "prod" 
  app_environment   = "prod" 
  network_environment = "prod"
  product           = "gdm"

  tags = {
    "repository" = "https://github.com/capterra/terraform.git"
  }
}