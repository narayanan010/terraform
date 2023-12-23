module "dns-zones" {
  source = "git::ssh://git@github.com/capterra/terraform.git//modules/networking/route-53/zones"
  zones = {
    "gdmstg_internal" = {
      domain_name         = "gdm-stg.internal"
      comment             = "${var.vpc_id} - association for private DNS for gdm internal"
      delegation_set_id   = null
      vpc                 = {
        "main-stg" = {
          id                  = var.vpc_id
          region              = var.modulecaller_source_region
        }
      }
      force_destroy       = false
    }
  }
}

resource "aws_route53_record" "bxapi-db-test1" {
  zone_id = module.dns-zones.route53_zone_zone_id.gdmstg_internal
  name    = "bxapi-db-test1"
  type    = "CNAME"
  ttl     = 60
  records = var.record_dns_value
}

resource "aws_route53_record" "gdm-bids-global-stg" {
  zone_id = module.dns-zones.route53_zone_zone_id.gdmstg_internal
  name    = "gdm-bids-global-stg"
  type    = "CNAME"
  ttl     = 60
  records = var.record_dns_value_gdm-bids-global-stg
}

resource "aws_route53_record" "gdm-vx-autobidder-global-stg" {
  zone_id = module.dns-zones.route53_zone_zone_id.gdmstg_internal
  name    = "gdm-vx-autobidder-global-stg"
  type    = "CNAME"
  ttl     = 60
  records = var.record_dns_value_gdm-vx-autobidder-global-stg
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
  environment       = "stg" 
  app_environment   = "stg" 
  network_environment = "stg"
  product           = "gdm"

  tags = {
    "repository" = "https://github.com/capterra/terraform.git"
  }
}