#This is needed to fetch the zone_id info from r53 zone. Keeping this data source inside module resulted in error while testing. Refer : https://issue.life/questions/41631966
data "aws_route53_zone" "zone" {
  provider     = aws.route53_account
  name         = var.modulecaller_dns_r53_zone
  private_zone = false
}


module "cf_dist_serverless" {
  source                = "../../../../../../modules/Cloudfront_Serverless_Apps-DR/sa-ppl-form/cloudfront_serverless_module-sa_ppl_form"
  name                  = "sa-ppl-form"
  stage                 = var.stage
  vertical              = "capterra"
  cert_hosted_zone_name = "capterra.com."
  cert_domain_name      = var.cert_domain_name
  hosted_zone_id        = data.aws_route53_zone.zone.zone_id
  region_aws            = "us-west-2"
  custom_max_ttl        = "0"
  custom_min_ttl        = "0"
  custom_default_ttl    = "0"

  providers = {
    aws.primary_cf_account     = aws.primary_cf_account
    aws.route53_account        = aws.route53_account
    aws.primary_cf_account_ue1 = aws.primary_cf_account_ue1
  }

  #Specify tags here
  tag_application         = "sa-ppl-form-dr"
  tag_app_component       = "capterra-dr"
  tag_function            = "cache-cdn"
  tag_business_unit       = "gdm"
  tag_app_environment     = var.stage
  tag_app_contacts        = "capterra_devops"
  tag_created_by          = "fabio.perrone@gartner.com"
  tag_system_risk_class   = "3"
  tag_region              = "us-west-2"
  tag_network_environment = var.stage
  tag_monitoring          = "false"
  tag_terraform_managed   = "true"
  tag_vertical            = "capterra"
  tag_product             = "sa-ppl-form"
  tag_environment         = var.stage
}
