module "cloudwatch-log-expiration_module" {
  source         = "../../../modules/cloudwatch-log-expiration-module"
  region_aws     = var.modulecaller_source_region
  retention_days = "1"
  lambda_timeout = 150
}
