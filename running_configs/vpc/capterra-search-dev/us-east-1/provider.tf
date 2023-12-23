data "aws_caller_identity" "current" {}

provider "aws" {
	alias =  "aws_sot_account"
 	version = "~>v2.55.0"
    region = "${var.modulecaller_source_region}"
    assume_role {
      #Below Role is SOT (SOURCE OF TRUTH for AZ-ID) account Role. This can be replaced in variables with any assume Role info. This is from account where everything is to be deployed. It is Capterra-Main Account
      role_arn		 = var.modulecaller_assume_role_sot_account
  	}
 }

provider "aws" {
 	alias =  "awscaller_account"
 	version = "~>v2.55.0"
    region = "${var.modulecaller_source_region}"
    assume_role {
      #Below Role is Deployer account Role. This can be replaced in variables with any assume Role info. This is from account where everything is to be deployed
      role_arn     = var.modulecaller_assume_role_deployer_account
   }
 }

	#Added this to fix "argument region not set error" while running plan. Bug in Provider.
 provider "aws" {
   region = var.modulecaller_source_region
 }
