#This is needed to fetch the zone_id info from r53 zone. Keeping this data source inside module resulted in error while testing. Refer : https://issue.life/questions/41631966
data "aws_route53_zone" "zone" {
  provider = "aws.route53_account"
  #name         = "capstage.net."
  name          = "${var.modulecaller_dns_r53_zone}"
  private_zone = false
}


module "cf_dist_serverless" {
  #source                         = "/Users/sargupta/Capterra-github/terraform/modules/Cloudfront_Serverless_Apps"
  #source                         = "/Users/sargupta/Capterra-github/terraform/modules/Cloudfront_Serverless_Apps-DR/capterra-compare-page/cloudfront_serverless_module-compare_ui"
  search                          = "git@github.com:capterra/terraform.git//modules/Cloudfront_Serverless_Apps-DR/capterra-compare-page/cloudfront_serverless_module-compare_ui"
  name    					             = "compare"
  #stage	 					               = "dev"
  stage                          = var.stage
  vertical 					             = "capterra"
  #cloudformationstackname        = "StackSet-SpotInstRoleDeployment-e6685df4-d2f7-46f3-b6aa-9c3c3d8636d9"
  cloudformationstackname        = var.cloudformationstackname
  #cloudformation_stack_output_endpoint_variable = "SpotinstRoleArn"
  cloudformation_stack_output_endpoint_variable = "ServiceEndpoint"
  #cert_domain_name            	 = "compare.capstage.net"
  cert_domain_name               = var.cert_domain_name
  cert_hosted_zone_name		       = "capterra.com."
  hosted_zone_id                 = "${data.aws_route53_zone.zone.zone_id}"
  region_aws                     = "us-east-1"
  primary_s3_bucket              = var.primary_s3_bucket
  s3_path_pattern                = "compare/assets/*"
  custom_max_ttl                 = "0"
  custom_min_ttl                 = "0"
  custom_default_ttl             = "0"

  #cf_aliases                    = ["serverlessapp99-test-alias.capstage.net"]
  #cf_forward_query_string_api   = "true"
  cf_forward_header_values       = ["Referer", "Nginx_GeoIp_Country_Code"]
  providers = {
    #aws = "aws"
    aws.primary_cf_account = "aws.primary_cf_account"
    aws.route53_account = "aws.route53_account"
    aws.primary_cf_account_ue1 = "aws.primary_cf_account_ue1"
  }

  #Specify tags here
    tag_application                    = "compare-ui-dr"
    tag_app_component                  = "capterra-dr"
    tag_function                       = "cache-cdn"
    tag_business_unit                  = "gdm"
    tag_app_environment                = "prod"
    tag_app_contacts                   = "capterra_devops"
    tag_created_by                     = "sarvesh.gupta/colin.taras@gartner.com"
    tag_system_risk_class              = "3"
    tag_region                         = "us-west-2"
    tag_network_environment            = "prod"             
    tag_monitoring                     = "false"
    tag_terraform_managed              = "true"
    tag_vertical                       = "capterra"
    tag_product                        = "compare-ui"
    tag_environment                    = "prod"

}
