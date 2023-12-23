terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 4.31.0"
      configuration_aliases = [aws.landing-account]
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.13.1"
    }
  }
  required_version = ">= 1.1.0"
}
