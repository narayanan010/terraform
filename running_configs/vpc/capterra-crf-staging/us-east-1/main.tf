data "aws_caller_identity" "current" {}

provider "aws" {
	alias =  "aws_sot_account"
 	version = "~> v2.55.0"
    region = "${var.modulecaller_source_region}"
    assume_role {
      #Below Role is SOT (SOURCE OF TRUTH for AZ-ID) account Role. This can be replaced in variables with any assume Role info. This is from account where everything is to be deployed. It is Capterra-Main Account
      role_arn		 = var.modulecaller_assume_role_sot_account
  	}
 }

provider "aws" {
 	alias =  "awscaller_account"
 	version = "~> v2.55.0"
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

module "aws_vpc_mod" {
    source                      = "git@github.com:capterra/terraform-vpc.git"
    #source                      = "../../../Capterra-Github/terraform-vpc"
    vpc_cidr_block              = "10.114.72.0/21"
    vpc_private_subnet_count    = "2"    
    vpc_private_subnet_cidr     = ["10.114.72.0/24","10.114.73.0/24"]
    vpc_public_subnet_count     = "2"
    vpc_public_subnet_cidr      = ["10.114.78.0/24","10.114.79.0/24"]
    #vpc_enable_dns_support      = "true"
    vpc_enable_classiclink      = "false"
    vpc_enable_dns_support      = "false"
    namespace                   = "capterra-crf"
    stage                       = "staging"
    region                      = "us-east-1"

    #Specify tags here
    tag_application                    = "capterra-crf"
    tag_app_component                  = "CRF"
    tag_function                       = "capterra-reviews"
    tag_business_unit                  = "GDM"
    tag_app_environment                = "staging"
    tag_app_contacts                   = "capterra-devops"
    tag_created_by                     = "sarvesh.gupta@gartner.com"
    tag_system_risk_class              = "3"
    tag_region                         = "us-east-1"
    tag_network_environment            = "staging"             
    tag_monitoring                     = "false"
    tag_terraform_managed              = "true"
    tag_vertical                       = "Reviews"
    tag_product                        = "CRF"
    tag_environment                    = "staging"

    providers = {
    aws.awscaller_account = "aws.awscaller_account"
    aws.aws_sot_account = "aws.aws_sot_account"
  }
}

