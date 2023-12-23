terraform {
  backend "s3" {}
}

data "aws_caller_identity" "current" {}

provider "aws" {
  alias  = "primary_cf_account"
  region = var.region
  assume_role {
    #Below Role is Primary account Role. This can be replaced in variables with any assume Role info. I used assume role from Sandbox
    role_arn = "arn:aws:iam::273213456764:role/assume-capterra-search-staging-admin"
  }
}

/*provider "aws" {
  alias  = "primary_cf_account_ue1"
  region = var.region
  assume_role {
    #Below Role is Primary account Role. This can be replaced in variables with any assume Role info. I used assume role from Sandbox
    role_arn = "arn:aws:iam::273213456764:role/assume-capterra-search-staging-admin"
  }
}*/

provider "aws" {
  alias  = "route53_account"
  region = var.region
  assume_role {
    #Below Role is R53 account Role. This can be replaced in variables with any assume Role info. I used assume role from Capterra
    role_arn = "arn:aws:iam::176540105868:role/assume-capterra-power-user"
  }
}

/*provider "aws" {
  alias  = "cloudformation_account"
  region = var.modulecaller_source_region
  assume_role {
    #Below Role is Primary account Role. This can be replaced in variables with any assume Role info.
    role_arn = var.modulecaller_assume_role_primary_account
  }
}*/

provider "aws" {
  alias  = "capterra-aws-admin"
  region = var.region
}

#Added this to fix "argument region not set error" while running plan. Bug in Provider.
provider "aws" {
  region = var.region
}
