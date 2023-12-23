module "cloudwatch-log-expiration_module" {
  source                = "../../../modules/cloudwatch-log-expiration-module"
  region_aws            = var.modulecaller_source_region
  retention_days        = "14"
  lambda_timeout        = 30
  cw_loggroups_excluded = ["/aws/msk/click-streaming-staging-001-ue1", "/aws/msk/rbr"]
}
