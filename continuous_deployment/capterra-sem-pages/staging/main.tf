#This is needed to fetch the zone_id info from r53 zone. Keeping this data source inside module resulted in error while testing. Refer : https://issue.life/questions/41631966
data "aws_route53_zone" "zone" {
  provider     = aws.route53_account
  name         = var.modulecaller_dns_r53_zone
  private_zone = false
}

module "cf_dist_serverless" {
  source                                        = "../cloudfront_serverless_module-sem_pages"
  name                                          = "sem-pages"
  stage                                         = var.stage
  vertical                                      = "capterra"
  cloudformationstackname                       = var.cloudformationstackname
  cloudformation_stack_output_endpoint_variable = "ServiceEndpoint"
  cert_domain_name                              = var.cert_domain_name
  cert_hosted_zone_name                         = "capstage.net."
  hosted_zone_id                                = data.aws_route53_zone.zone.zone_id
  region_aws                                    = "us-east-1"
  primary_s3_bucket                             = var.primary_s3_bucket
  s3_path_pattern                               = "semCompare/assets/*"

  #Added below section for supporting the SEM-DISPLAY & SEM-SEARCH files rendering from S3 via OAI. Added Path-Pattern for Assets/* - Date 02/13/2021

  s3_path_pattern_semCompareStatic = "semCompare/semCompareStatic/*"
  s3_path_pattern_semDisplay       = "semDisplay/assets/*"
  s3_path_pattern_semSearch        = "semSearch/assets/*"

  #Added below section for supporting the SEMCOMPAREMOBILE files rendering from S3 via OAI. Added Path-Pattern for Assets/* - Date 05/02/2021

  s3_path_pattern_semCompareMobile = "semCompareMobile/semCompareMobileStatic/*"

  #Added below section for supporting the SEMCOMPAREMOBILE-ASSETS files rendering from S3 via OAI. Added Path-Pattern for Assets/* - Date 07/21/2021

  s3_path_pattern_semCompareMobile_assets = "semCompareMobile/assets/*"

  #Added below section for supporting the semCompareServices-ASSETS files rendering from S3 via OAI. Added Path-Pattern for Assets/* - Date 03/16/2023

  s3_path_pattern_semCompareServices_assets = "semCompareServices/assets/*"

  #Added below section for supporting the semCompareServicesMobile-ASSETS files rendering from S3 via OAI. Added Path-Pattern for Assets/* - Date 03/16/2023

  s3_path_pattern_semCompareServicesMobile_assets = "semCompareServicesMobile/assets/*"

  #Added below section for supporting the semPPL-ASSETS files rendering from S3 via OAI. Added Path-Pattern for Assets/* - Date 05/23/2023

  s3_path_pattern_semPPL_assets = "semPPL/assets/*"

  #Added below section for supporting the getbetterlist-ASSETS files rendering from S3 via OAI. Added Path-Pattern for Assets/* - Date 07/25/2023

  s3_path_pattern_getbetterlist_assets = "semShortlist/assets/*"


  #Section Ends here
  custom_max_ttl                 = "0"
  custom_min_ttl                 = "0"
  custom_default_ttl             = "0"
  cf_origin_access_control       = "E36MGTTVG84YC7"
  cf_forward_header_values = ["Referer"]
  providers = {
    aws.primary_cf_account = aws.primary_cf_account
    aws.route53_account    = aws.route53_account
  }

}
