
module "aws_vpc_mod" {
    source                      = "git@github.com:capterra/terraform-vpc.git"
    #source                      = "../../../Capterra-Github/terraform-vpc"
    vpc_cidr_block              = "10.114.88.0/21"
    vpc_private_subnet_count    = "2"    
    vpc_private_subnet_cidr     = ["10.114.88.0/24","10.114.89.0/24"]
    vpc_public_subnet_count     = "2"
    vpc_public_subnet_cidr      = ["10.114.94.0/24","10.114.95.0/24"]
    #vpc_enable_dns_support      = "true"
    vpc_enable_classiclink      = "false"
    vpc_enable_dns_support      = "false"
    namespace                   = "capterra-crf"
    stage                       = "prod"
    region                      = "us-east-1"

    #Specify tags here
    tag_application                    = "capterra-crf"
    tag_app_component                  = "CRF"
    tag_function                       = "capterra-reviews"
    tag_business_unit                  = "GDM"
    tag_app_environment                = "prod"
    tag_app_contacts                   = "capterra-devops"
    tag_created_by                     = "sarvesh.gupta@gartner.com"
    tag_system_risk_class              = "3"
    tag_region                         = "us-east-1"
    tag_network_environment            = "prod"             
    tag_monitoring                     = "false"
    tag_terraform_managed              = "true"
    tag_vertical                       = "Reviews"
    tag_product                        = "CRF"
    tag_environment                    = "prod"

    providers = {
    aws.awscaller_account = "aws.awscaller_account"
    aws.aws_sot_account = "aws.aws_sot_account"
  }
}

