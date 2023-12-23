terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 4.37.0"
      configuration_aliases = [aws.primary_cf_account, aws.route53_account]
    }
    external = {
      source  = "hashicorp/external"
      version = ">= 2.2.0"
    }
  }
  required_version = ">= 1.2.9"
}
