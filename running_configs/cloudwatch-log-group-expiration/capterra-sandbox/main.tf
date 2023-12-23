module "cloudwatch-log-expiration_module" {
  source                   = "../../../modules/cloudwatch-log-expiration-module"
  region_aws               = var.modulecaller_source_region
  retention_days           = "1"
  lambda_timeout           = var.lambda_timeout
  eventbridge_rule_enabled = true
  cw_loggroups_excluded    = ["/aws/lambda/test2_vpc", "/aws/imagebuilder/test2"]
}