terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.55"
    }
  }
}

data "aws_caller_identity" "current" {}

provider "aws" {
  alias  = "primary_cf_account"
  region = var.modulecaller_source_region
  assume_role {
    #Below Role is Primary account Role. This can be replaced in variables with any assume Role info. I used assume role from Sandbox
    role_arn = var.modulecaller_assume_role_primary_account
  }
}

provider "aws" {
  alias  = "primary_cf_account_ue1"
  region = var.modulecaller_source_region_ue1
  assume_role {
    #Below Role is Primary account Role. This can be replaced in variables with any assume Role info. I used assume role from Sandbox
    role_arn = var.modulecaller_assume_role_primary_account
  }
}

provider "aws" {
  alias  = "route53_account"
  region = var.modulecaller_source_region
  assume_role {
    #Below Role is R53 account Role. This can be replaced in variables with any assume Role info. I used assume role from Capterra
    role_arn = var.modulecaller_assume_role_dns_account
  }
}

provider "aws" {
  alias  = "capterra-aws-admin"
  region = var.modulecaller_source_region
}

#Added this to fix "argument region not set error" while running plan. Bug in Provider.
provider "aws" {
  region = var.modulecaller_source_region
}
