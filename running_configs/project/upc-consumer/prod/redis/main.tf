module "aws_redis_module" {
    #source                      = "git@github.com:capterra/terraform.git//modules/elasticache/redis"
    source                  = "../../../../../../../Capterra-Github/terraform/modules/elasticache/redis"

    #Elasticache vars
    cluster_mode_enabled     = false
    region                  = "us-east-1"
    cluster_id              = "upc-consumer-prod-redis"
    #engine                  = ""
    node_type               = "cache.t3.small"
    #num_cache_nodes         = ""
    #parameter_group_name    = ""
    #engine_version          = ""
    #port                    = ""
    subnet_list_to_add_to_subnet_group  = ["subnet-87666faa","subnet-1529d05d","subnet-082cd9abed1c1291f"]
    #maintenance_window      = ""
    #snapshot_retention_limit = 
    #snapshot_window = "03:30-04:30"
    cluster_size             = "1"
    transit_encryption_enabled = true
    at_rest_encryption_enabled = true
    #elasticache_existing_subnet_group_name = "tf-custom-subnetgroup"
    add_subnet_group         = true
    #availability_zones       = ["us-east-1c","us-east-1d"]


    #SG vars
    vpc_id_for_sg                   = "vpc-c2ecc1a4"
    use_existing_security_groups    = false
    #existing_security_groups        = []
    #allowed_security_groups         = ["sg-xxx"]
    allowed_cidr_blocks             = ["10.114.24.0/21","10.114.80.0/28"]


    #Specify tags here
    tag_application                    = "upc-consumer"
    tag_app_component                  = "redis"
    tag_function                       = "cache"
    tag_business_unit                  = "GDM"
    tag_app_environment                = "prod"
    tag_app_contacts                   = "capterra_devops@gartner.com"
    tag_created_by                     = "sarvesh.gupta@gartner.com"
    tag_system_risk_class              = "3"
    tag_region                         = "us-east-1"
    tag_network_environment            = "cache"             
    tag_monitoring                     = "no"
    tag_terraform_managed              = "true"
    tag_vertical                       = "capterra"
    tag_product                        = "upc-consumer"
    tag_environment                    = "prod"

    providers = {
    aws.awscaller_account = "aws.awscaller_account"
    aws.aws_sot_account = "aws.aws_sot_account"
  }
}