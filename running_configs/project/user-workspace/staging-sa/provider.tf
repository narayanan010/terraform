terraform {
  backend "s3" {}
}

data "aws_caller_identity" "current" {}

provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::273213456764:role/assume-capterra-search-staging-admin"
  }
  default_tags {
    tags = {
      ENVIRONMENT     = var.environment
      iac_platform    = "terraform"
      project         = "userworkspace"
      app_environment = "staging"
      application     = "userworkspace"
      business_unit   = "dm"
      app_contacts    = "capterra_devops"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "capterra"
  assume_role {
    role_arn = "arn:aws:iam::176540105868:role/assume-capterra-admin"
  }
  default_tags {
    tags = {
      ENVIRONMENT     = var.environment
      iac_platform    = "terraform"
      project         = "userworkspace"
      app_environment = var.environment
      application     = "userworkspace"
      business_unit   = "dm"
      app_contacts    = "capterra_devops"
    }
  }
}
