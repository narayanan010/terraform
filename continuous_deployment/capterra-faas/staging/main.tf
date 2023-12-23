#This is needed to fetch the zone_id info from r53 zone. Keeping this data source inside module resulted in error while testing. Refer : https://issue.life/questions/41631966
data "aws_route53_zone" "zone" {
  provider = "aws.route53_account"
  #name         = "capstage.net."
  name          = "${var.modulecaller_dns_r53_zone}"
  private_zone = false
}


module "cf_dist_serverless" {
  #source                         = "/Users/sargupta/Capterra-github/terraform/modules/Cloudfront_Serverless_Apps"
  source                         = "../cloudfront_serverless_module-faas"
  name    					             = "capterra-faas"
  #stage	 					               = "dev"
  stage                          = var.stage
  vertical 					             = "capterra"
  #cloudformationstackname        = var.cloudformationstackname
  #cloudformation_stack_output_endpoint_variable = "ServiceEndpoint"
  #cert_domain_name            	 = "faas.capstage.net"
  cert_domain_name               = var.cert_domain_name
  cert_hosted_zone_name		       = "capstage.net."
  hosted_zone_id                 = "${data.aws_route53_zone.zone.zone_id}"
  region_aws                     = "us-east-1"
  primary_s3_bucket              = var.primary_s3_bucket
  s3_path_pattern                = "_next/static/*"
  custom_max_ttl                 = "0"
  custom_min_ttl                 = "0"
  custom_default_ttl             = "0"
  #s3_path_pattern_storybook      = "storybook/*"

  #cf_aliases                    = ["serverlessapp99-test-alias.capstage.net"]
  #cf_forward_query_string_api   = "true"
  cf_forward_header_values       = ["Referer", "Nginx_GeoIp_Country_Code"]
  providers = {
    #aws = "aws"
    aws.primary_cf_account = "aws.primary_cf_account"
    aws.route53_account = "aws.route53_account"
  }

  #Specify tags here
    tag_application                    = "capterra-faas"
    tag_app_component                  = "capterra"
    tag_function                       = "cache-cdn"
    tag_business_unit                  = "gdm"
    tag_app_environment                = "staging"
    tag_app_contacts                   = "capterra_devops"
    tag_created_by                     = "sarvesh.gupta/colin.taras@gartner.com"
    tag_system_risk_class              = "3"
    tag_region                         = "us-east-1"
    tag_network_environment            = "staging"             
    tag_monitoring                     = "false"
    tag_terraform_managed              = "true"
    tag_vertical                       = "capterra"
    tag_product                        = "capterra-faas"
    tag_environment                    = "staging"

}