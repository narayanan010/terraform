#This is needed to fetch the zone_id info from r53 zone. Keeping this data source inside module resulted in error while testing. Refer : https://issue.life/questions/41631966
data "aws_route53_zone" "zone" {
  provider     = aws.route53_account
  name         = var.modulecaller_dns_r53_zone
  private_zone = false
}

module "cf_dist_serverless" {
  source                = "../../../../../modules/Cloudfront_Serverless_Apps/user-workspace"
  name                  = "user-workspace"
  stage                 = var.stage
  vertical              = "capterra"
  cert_hosted_zone_name = "capstage.net."
  cert_domain_name      = var.cert_domain_name
  hosted_zone_id        = data.aws_route53_zone.zone.zone_id
  region_aws            = var.region
  custom_max_ttl        = "0"
  custom_min_ttl        = "0"
  custom_default_ttl    = "0"
  bucketName            = "capterra-user-workspace-staging"
  cloudformationstackname = "user-workspace-staging"
  cloudformation_stack_output_endpoint_variable = "ServiceEndpoint"
  cloudformation_stack_output_endpoint_variable_GraphQL = "GraphQlApiUrl"
  wafID = "arn:aws:wafv2:us-east-1:273213456764:global/webacl/capterra-search-staging-waf/0b48cf0a-108c-41c8-996c-864b3f2db1d3"

  providers = {
    aws.primary_cf_account     = aws.primary_cf_account
    aws.route53_account        = aws.route53_account
  }

  #Specify tags here
  tag_application         = "user-workspace"
  tag_app_component       = "capterra"
  tag_function            = "cache-cdn"
  tag_business_unit       = "gdm"
  tag_app_environment     = var.stage
  tag_app_contacts        = "capterra_devops"
  tag_created_by          = "yajush.garg@gartner.com"
  tag_system_risk_class   = "3"
  tag_region              = var.region
  tag_network_environment = var.stage
  tag_monitoring          = "false"
  tag_terraform_managed   = "true"
  tag_vertical            = "capterra"
  tag_product             = "user-workspace"
  tag_environment         = var.stage
}
