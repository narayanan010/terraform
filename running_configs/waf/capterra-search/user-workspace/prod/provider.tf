provider "aws" {
  alias  = "primary"
  region = var.modulecaller_source_region
  assume_role {
    role_arn = var.modulecaller_assume_role_deployer_account
  }
}