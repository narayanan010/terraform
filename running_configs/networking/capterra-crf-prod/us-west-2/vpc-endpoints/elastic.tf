module "elastic-vpc-endpoints" {
  source = "git::ssh://git@github.com/capterra/terraform.git//modules/networking/vpc-endpoint"
  vpc_id = var.vpc_id
  interface_vpc_endpoints = {
    "elastic_cloud" = {
      name                = "com.amazonaws.vpce.us-west-2.vpce-svc-0e69febae1fb91870"
      subnet_ids          = var.elastic_vpc_endpoint_subnet_ids
      policy              = null
      security_group_ids  = [aws_security_group.elastic_cloud_endpoint.id]
      private_dns_enabled = false
      application_tag     = "elastic"
    }
  }
}

module "dns-zones" {
  source = "git::ssh://git@github.com/capterra/terraform.git//modules/networking/route-53/zones"
  zones = {
    "elastic_cloud" = {
      domain_name         = "vpce.${var.modulecaller_source_region}.aws.elastic-cloud.com"
      comment             = "${var.vpc_id} - Private Zone for Elastic Cloud VPC Endpoint"
      delegation_set_id   = null
      vpc                 = {
        "crf-prod" = {
          id                  = var.vpc_id
          region              = var.modulecaller_source_region
        }
      }
      force_destroy       = false
    }
  }
}

resource "aws_route53_record" "elastic_cloud" {
  zone_id = module.dns-zones.route53_zone_zone_id.elastic_cloud
  name    = "*.vpce.${var.modulecaller_source_region}.aws.elastic-cloud.com"
  type    = "A"

  alias {
    name  = module.elastic-vpc-endpoints.interface_vpc_endpoints[0].dns_entry[0].dns_name
    zone_id = module.elastic-vpc-endpoints.interface_vpc_endpoints[0].dns_entry[0].hosted_zone_id
    evaluate_target_health = false
  }
}

module "tags_resource_module" {
  source = "git::ssh://git@github.com/capterra/terraform.git//modules/tagging-resource-module"

  application       = "elasticsearch"
  app_component     = "network"
  function          = "vpc_endpoint"
  business_unit     = "gdm"
  app_contacts      = "capterra_devops"
  created_by        = "fabio.perrone@gartner.com"
  system_risk_class = "3"
  region            = var.modulecaller_source_region
  monitoring        = "false"
  terraform_managed = "true"
  vertical          = var.vertical
  environment       = "prod-dr" 
  app_environment   = "prod-dr"
  network_environment = "prod"
  product           = "gdm"

  tags = {
    "repository" = "https://github.com/capterra/terraform.git"
  }
}
