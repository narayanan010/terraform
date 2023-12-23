#This is needed to fetch the zone_id info from r53 zone. Keeping this data source inside module resulted in error while testing. Refer : https://issue.life/questions/41631966
data "aws_route53_zone" "zone" {
  provider               = aws.route53_account
  name                   = var.modulecaller_dns_r53_zone
  private_zone           = false
}

module "cf_dist_serverless" {
  source                 = "../../../../../modules/Cloudfront_Serverless_Apps/capterra-faas-examples"
  name                   = "capterra-faas-examples"
  stage                  = var.stage
  vertical               = "capterra"
  cert_hosted_zone_name  = "capterra.com."
  cert_domain_name       = var.cert_domain_name
  hosted_zone_id         = data.aws_route53_zone.zone.zone_id
  region_aws             = var.region
  custom_max_ttl         = "0"
  custom_min_ttl         = "0"
  custom_default_ttl     = "0"
  origin_path            = "/prod"
  bucketname             = "forms-as-a-service-examples-prod"
  cf_default_root_object = "index.html"
  web_acl_arn            = var.waf_arn 
  providers = {
    aws.primary_cf_account     = aws.primary_cf_account
    aws.route53_account        = aws.route53_account
  }
}
