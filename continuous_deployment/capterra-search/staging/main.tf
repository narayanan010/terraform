data "aws_route53_zone" "zone" {
  provider     = aws.route53_account
  name         = var.modulecaller_dns_r53_zone
  private_zone = false
}


module "cf_dist_serverless" {
  source                         = "../cloudfront_serverless_module-search"
  name    					             = "capterra-search"
  stage                          = var.stage
  vertical 					             = "capterra"
  cloudformationstackname        = var.cloudformationstackname
  cloudformation_stack_output_endpoint_variable = "ServiceEndpoint"
  cert_domain_name               = var.cert_domain_name
  cert_hosted_zone_name		       = "capstage.net."
  hosted_zone_id                 = data.aws_route53_zone.zone.zone_id
  region_aws                     = "us-east-1"
  primary_s3_bucket              = var.primary_s3_bucket
  s3_path_pattern                = "search/assets/*"
  custom_max_ttl                 = "0"
  custom_min_ttl                 = "0"
  custom_default_ttl             = "0"
  s3_path_pattern_storybook      = "storybook/*"
  cf_forward_header_values       = ["Referer", "Nginx_GeoIp_Country_Code"]
  cf_origin_access_control                      = "E1B1L1U9027ANP"
  providers = {
    aws.primary_cf_account = aws.primary_cf_account
    aws.route53_account    = aws.route53_account
  }
}
module "tags_resource_module" {
  source = "git@github.com:capterra/terraform.git//modules/tagging-resource-module"

  application         = "capterra-search"
  app_component       = "capterra"
  function            = "cache-cdn"
  business_unit       = "gdm"
  app_environment     = "staging"
  app_contacts        = "capterra_devops"
  created_by          = "fabio.perrone@gartner.com"
  system_risk_class   = "3"
  region              = var.modulecaller_source_region
  network_environment = "staging"
  monitoring          = "false"
  terraform_managed   = "true"
  vertical            = "capterra"
  product             = "capterra-search"
  environment         = "staging"
}