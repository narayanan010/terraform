module "aws_redis_module" {
    #source                      = "git@github.com:capterra/terraform.git//modules/elasticache/redis"
    source                  = "../../../../../../../Capterra-Github/terraform/modules/elasticache/redis"

    #Elasticache vars
    cluster_mode_enabled     = true
    region                  = "us-east-1"
    cluster_id              = "upc-consumer-staging-redis"
    #engine                  = ""
    node_type               = "cache.t3.micro"
    #num_cache_nodes         = ""
    #parameter_group_name    = ""
    #engine_version          = ""
    #port                    = ""
    subnet_list_to_add_to_subnet_group  = ["subnet-69726f44","subnet-6414d82c","subnet-017b7c5a2326dd583"]
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
    vpc_id_for_sg                   = "vpc-60714d06"
    use_existing_security_groups    = false
    #existing_security_groups        = []
    #allowed_security_groups         = ["sg-xxx"]
    allowed_cidr_blocks             = ["10.114.32.0/21"]


    #Specify tags here
    tag_application                    = "upc-consumer"
    tag_app_component                  = "redis"
    tag_function                       = "cache"
    tag_business_unit                  = "GDM"
    tag_app_environment                = "staging"
    tag_app_contacts                   = "capterra-devops@gartner.com"
    tag_created_by                     = "sarvesh.gupta@gartner.com"
    tag_system_risk_class              = "3"
    tag_region                         = "us-east-1"
    tag_network_environment            = "staging"             
    tag_monitoring                     = "no"
    tag_terraform_managed              = "true"
    tag_vertical                       = "capterra"
    tag_product                        = "upc-consumer"
    tag_environment                    = "staging"

    providers = {
    aws.awscaller_account = "aws.awscaller_account"
    aws.aws_sot_account = "aws.aws_sot_account"
  }
}