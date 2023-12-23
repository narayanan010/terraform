terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 4.50.0"
      configuration_aliases = [aws.primary_cf_account, aws.route53_account]
    }
    external = {
      source  = "hashicorp/external"
      version = ">= 2.2.0"
    }
  }
  required_version = ">= 1.2.9"
}

data "terraform_remote_state" "common_resources" {
  backend = "s3"
  config = {
    bucket         = "capterra-terraform-state"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "capterra-terraform-lock-table"
    key            = "cloudfront/oac/crf/staging/terraform.tfstate"
  }
}
