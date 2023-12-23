 terraform {
    backend "s3" {}
}

data "aws_caller_identity" "current" {}
 
 provider "aws" {
 	 alias =  "awscaller_account"
     region = "${var.modulecaller_source_region}"
     assume_role {
       #Below Role is Callee account Role. This can be replaced in variables with any assume Role info.
       role_arn     = var.modulecaller_assume_role_primary_account
   }
 }

#Added this to fix "argument region not set error" while running plan. Bug in Provider.
 provider "aws" {
   region = var.modulecaller_source_region
 }