terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 4.20.0"
      configuration_aliases = [aws.route53_account]
    }
  }
  required_version = ">= 1.1.0"
}
