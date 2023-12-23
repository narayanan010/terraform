#This is needed to fetch the zone_id info from r53 zone. Keeping this data source inside module resulted in error while testing. Refer : https://issue.life/questions/41631966
data "aws_route53_zone" "zone" {
  provider     = aws.route53_account
  name         = var.modulecaller_dns_r53_zone
  private_zone = false
}

module "cf_dist_serverless" {
  source                                        = "../cloudfront_serverless_module-user-workspace"
  name                                          = "capterra-user-workspace"
  stage                                         = var.stage
  vertical                                      = "capterra"
  cloudformationstackname                       = var.cloudformationstackname
  cloudformation_stack_output_endpoint_variable = "ServiceEndpoint"
  cert_domain_name                              = var.cert_domain_name
  cert_hosted_zone_name                         = "capstage.net."
  hosted_zone_id                                = data.aws_route53_zone.zone.zone_id
  region_aws                                    = "us-east-1"
  primary_s3_bucket                             = var.primary_s3_bucket
  s3_path_pattern                               = "_next/static/*"
  custom_max_ttl                                = "0"
  custom_min_ttl                                = "0"
  custom_default_ttl                            = "0"
  cf_forward_header_values                      = ["Referer", "Nginx_GeoIp_Country_Code"]
  cache_policy_redirect_lambda                  = data.terraform_remote_state.common_resources.outputs.cache_policy_redirect_lambda.id
  cache_policy_standard                         = data.terraform_remote_state.common_resources.outputs.cache_policy_standard.id
  cache_policy_default                          = data.terraform_remote_state.common_resources.outputs.cache_policy_default.id
  cf_origin_access_control                      = data.terraform_remote_state.common_resources.outputs.aws_cloudfront_origin_access_control.id

  providers = {
    aws.primary_cf_account = aws.primary_cf_account
    aws.route53_account    = aws.route53_account
  }
}

module "tags_resource_module" {
  source = "git@github.com:capterra/terraform.git//modules/tagging-resource-module"

  application         = var.tag_application
  app_component       = "capterra"
  function            = "cache-cdn"
  business_unit       = "gdm"
  app_environment     = "staging"
  app_contacts        = "capterra_devops"
  created_by          = "yajush.garg@gartner.com"
  system_risk_class   = "3"
  region              = "us-east-1"
  network_environment = "staging"
  monitoring          = "false"
  terraform_managed   = "true"
  vertical            = "capterra"
  product             = "capterra-user-workspace"
  environment         = "staging"
}
