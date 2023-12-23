#This is needed to fetch the zone_id info from r53 zone. Keeping this data source inside module resulted in error while testing. Refer : https://issue.life/questions/41631966
data "aws_route53_zone" "zone" {
  provider = "aws.route53_account"
  #name         = "capstage.net."
  name          = "${var.modulecaller_dns_r53_zone}"
  private_zone = false
}


module "apigw_cd" {
  #source                         = "/Users/sargupta/Capterra-github/terraform/modules/api-gw-custom-domain"
  source                         = "../../../modules/api-gw-custom-domain"
  name    					             = "dd"
  stage                          = var.stage
  vertical 					             = "capterra"
  cert_hosted_zone_name		       = "capstage.net."
  hosted_zone_id                 = "${data.aws_route53_zone.zone.zone_id}"
  region_aws                     = "us-east-1"
  apigw_custom_domain_name       = var.apigw_custom_domain_name
  api_id                         = var.api_id
  api_stage_name                 = var.api_stage_name

  providers = {
    #aws = "aws"
    aws.primary_cf_account = "aws.primary_cf_account"
    aws.route53_account = "aws.route53_account"
  }

  #Specify tags here
    tag_application                    = "declared-data"
    tag_app_component                  = "capterra"
    tag_function                       = "custom-domain"
    tag_business_unit                  = "gdm"
    tag_app_environment                = "staging"
    tag_app_contacts                   = "capterra_devops"
    tag_created_by                     = "sarvesh.gupta@gartner.com"
    tag_system_risk_class              = "3"
    tag_region                         = "us-east-1"
    tag_network_environment            = "staging"             
    tag_monitoring                     = "false"
    tag_terraform_managed              = "true"
    tag_vertical                       = "capterra"
    tag_product                        = "declared-data"
    tag_environment                    = "staging"
}