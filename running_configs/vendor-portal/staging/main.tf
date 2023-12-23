data "aws_caller_identity" "current" {}


terraform {
     backend "s3" {}
 }


provider "aws" {
  alias =  "aws_sot_account"
  version = "~>v2.55.0"
    region = "${var.modulecaller_source_region}"
    assume_role {
      #Below Role is SOT (SOURCE OF TRUTH for AZ-ID) account Role. This can be replaced in variables with any assume Role info. This is from account where everything is to be deployed. It is Capterra-Main Account
      role_arn     = var.modulecaller_assume_role_sot_account
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



module "aws_redis_module" {
    source                      = "git@github.com:capterra/terraform.git//modules/elasticache/redis"
    #source                  = "../../../Capterra-Github/terraform/modules/elasticache/redis"

    #Elasticache vars
    cluster_mode_enabled     = true
    region                  = "us-east-1"
    cluster_id              = "vendor-portal-staging"
    #engine                  = ""
    #node_type               = ""
    #num_cache_nodes         = ""
    #parameter_group_name    = ""
    #engine_version          = ""
    #port                    = ""
    subnet_list_to_add_to_subnet_group  = ["subnet-089258bf9059259d3"]
    #maintenance_window      = ""
    #snapshot_retention_limit = 
    #snapshot_window = "03:30-04:30"
    cluster_size             = "1"
    transit_encryption_enabled = true
    at_rest_encryption_enabled = false
    elasticache_existing_subnet_group_name = "capterrasearchstagingecsubnetgroup001"


    #SG vars
    vpc_id_for_sg                   = "vpc-0715b585d83b5dac0"
    use_existing_security_groups    = true
    existing_security_groups        = ["sg-04dd5d676fd62244e"]
    #allowed_security_groups         = ["sg-046c0356cdad26e0f"]
    #allowed_cidr_blocks             = ["23.23.23.23/32"]


    #Specify tags here
    tag_application                    = "vendor-portal"
    tag_app_component                  = "redis"
    tag_function                       = "cache"
    tag_business_unit                  = "capterra"
    tag_app_environment                = "staging"
    tag_app_contacts                   = "capterra_devops@gartner.com"
    tag_created_by                     = "capterra_devops@gartner.com"
    tag_system_risk_class              = "3"
    tag_region                         = "us-east-1"
    tag_network_environment            = "private"             
    tag_monitoring                     = "true"
    tag_terraform_managed              = "true"
    tag_vertical                       = "capterra"
    tag_product                        = "vendor-portal"
    tag_environment                    = "staging"

    providers = {
    aws.awscaller_account = "aws.awscaller_account"
    aws.aws_sot_account = "aws.aws_sot_account"
  }
}