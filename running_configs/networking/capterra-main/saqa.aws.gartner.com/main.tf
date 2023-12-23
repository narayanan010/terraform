module "dns-zones" {
  source = "git::ssh://git@github.com/capterra/terraform.git//modules/networking/route-53/zones"
  zones = {
    "saqa-aws-gartner" = {
      domain_name         = "saqa.aws.gartner.com"
      comment             = "${var.vpc_id} - association with private DNS for Stage VPC for Software Advice"
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

resource "aws_route53_record" "mapping-saqa-aws-gartner" {
  zone_id = module.dns-zones.route53_zone_zone_id.saqa-aws-gartner
  name    = "mapping.saqa.aws.gartner.com"
  type    = "CNAME"
  ttl     = 60
  records = var.record_dns_value
}

module "tags_resource_module" {
  source = "git::ssh://git@github.com/capterra/terraform.git//modules/tagging-resource-module"

  application         = "r53"
  app_component       = "network"
  function            = "internal"
  business_unit       = "gdm"
  app_contacts        = "capterra_devops"
  created_by          = "narayanan.narasimhan@gartner.com"
  system_risk_class   = "3"
  region              = var.modulecaller_source_region
  monitoring          = "false"
  terraform_managed   = "true"
  vertical            = var.vertical
  environment         = "stg" 
  app_environment     = "stg" 
  network_environment = "stg"
  product             = "gdm"

  tags = {
    "repository" = "https://github.com/capterra/terraform.git"
  }
}