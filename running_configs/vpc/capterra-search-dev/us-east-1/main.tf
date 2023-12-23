module "aws_vpc_ue1_001" {
    source                     = "git@github.com:capterra/terraform-vpc.git"
    vpc_cidr_block              = "10.114.116.0/22"
    vpc_private_subnet_count    = "2"    
    vpc_private_subnet_cidr     = ["10.114.116.0/26","10.114.116.64/26"]
    vpc_public_subnet_count     = "2"
    vpc_public_subnet_cidr      = ["10.114.117.0/26","10.114.117.64/26"]
    vpc_enable_dns_support      = "true"
    vpc_enable_classiclink      = "false"
    namespace                   = "search"
    stage                       = "dev"
    region                      = "us-east-1"

    #Specify tags here
    tag_application                    = "search"
    #tag_app_component                  = "tagappcomp"
    #tag_function                       = "testfunction"
    #tag_business_unit                  = "testbusiness_unit"
    tag_app_environment                = "dev"
    #tag_app_contacts                   = "test_app_contacts"
    #tag_created_by                     = "testtag_created_by"
    #tag_system_risk_class              = "testtag_system_risk_class"
    tag_region                         = "us-east-1"
    tag_network_environment            = "N/A"             
    tag_monitoring                     = "N/A"
    tag_terraform_managed              = "true"
    tag_vertical                       = "capterra"
    tag_product                        = "search"
    tag_environment                    = "dev"

    providers = {
    aws.awscaller_account = "aws.awscaller_account"
    aws.aws_sot_account = "aws.aws_sot_account"
  }
}

module "lambda_sg" {
    source = "git@github.com:capterra/terraform-ec2.git//terraform-sg"
    vpc_id  = "vpc-0b340ad818cf0648b"
    region  = "us-east-1"
    env = "dev"
    product = "lambda"
}

module "elasticcache_sg" {
    source = "git@github.com:capterra/terraform-ec2.git//terraform-sg"
    vpc_id  = "${module.aws_vpc_ue1_001.vpc_id}"
    region  = "us-east-1"
    env = "dev"
    product = "elasticcache"
}

