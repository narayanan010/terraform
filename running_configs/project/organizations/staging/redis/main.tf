module "aws_redis_module" {
    #source                      = "git@github.com:capterra/terraform.git//modules/elasticache/redis"
    source                      = "../../../../../modules/elasticache/redis"

    #Elasticache vars
    cluster_mode_enabled     = true
    region                  = "us-east-1"
    cluster_id              = "organizations-staging"
    node_type               = "cache.t3.micro"
    parameter_group_name    = "default.redis5.0.cluster.on"
    engine_version          = "5.0.6"
    port                    = "6379"
    subnet_list_to_add_to_subnet_group  = ["subnet-69726f44","subnet-6414d82c","subnet-017b7c5a2326dd583"]
    cluster_size             = 1
    transit_encryption_enabled = true
    at_rest_encryption_enabled = true
    add_subnet_group         = true
    cluster_az_ids           = ["us-east-1a","us-east-1c"]


    #SG vars
    vpc_id_for_sg                   = "vpc-60714d06"
    use_existing_security_groups    = false
    allowed_cidr_blocks             = ["10.114.32.0/21","10.114.24.128/32"]
    allowed_prefix_list             = ["pl-09e58e0bd3c8445a6"]

    providers = {
      aws.untagged = aws.untagged
    }
}