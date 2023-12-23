data "aws_caller_identity" "current" {}

provider "aws" {
 	version = "~> 2.55.0"
  region = var.region
  assume_role {
    role_arn = "arn:aws:iam::176540105868:role/assume-capterra-power-user"
  }
}

provider "aws" {
	alias =  "aws_sot_account"
 	version = "~> 2.55.0"
    region = var.region
    assume_role {
      role_arn		 = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"
  	}
}

provider "aws" {
 	alias =  "awscaller_account"
 	version = "~> 2.55.0"
    region = var.region
    assume_role {
      role_arn		 = "arn:aws:iam::176540105868:role/assume-capterra-admin-batch"
   }
}
module "aws_vpc_mod" {
    source                      = "git@github.com:capterra/terraform-vpc.git"
    
    vpc_cidr_block              = "10.114.88.0/22"
    vpc_private_subnet_count    = "2"    
    vpc_private_subnet_cidr     = ["10.114.88.0/25","10.114.88.128/25"]
    vpc_public_subnet_count     = "2"
    vpc_public_subnet_cidr      = ["10.114.89.0/25","10.114.89.128/25"]

    vpc_enable_dns_support      = "true"
    vpc_enable_classiclink      = "false"
    namespace                   = "capterra"
    stage                       = "dev"
    region                      = "ap-south-1"

    providers = {
      aws.awscaller_account = aws.awscaller_account
      aws.aws_sot_account = aws.aws_sot_account
  }
}