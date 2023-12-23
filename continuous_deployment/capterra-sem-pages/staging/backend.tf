terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 4.45.0"
      configuration_aliases = [aws.primary_cf_account, aws.route53_account]
    }
  }
  required_version = ">= 1.3.5"
}
