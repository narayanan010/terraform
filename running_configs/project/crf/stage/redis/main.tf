module "aws_redis_module" {
    source                              = "git@github.com:capterra/terraform.git//modules/elasticache/redis"
    #Elasticache vars
    cluster_mode_enabled                = false
    region                              = "us-east-1"
    cluster_id                          = "crf-monorepo-staging-cluster"
    node_type                           = "cache.t3.micro"
    engine_version                      = "7.0"
    parameter_group_name                = "default.redis7"
    port                                = "6379"    
    subnet_list_to_add_to_subnet_group  = ["subnet-69726f44","subnet-6414d82c","subnet-017b7c5a2326dd583"]
    maintenance_window                  = "sat:05:00-sun:03:00"
    snapshot_retention_limit            = 3
    snapshot_window                     = "03:30-04:30"
    cluster_size                        = "2"
    transit_encryption_enabled          = true
    at_rest_encryption_enabled          = true
    add_subnet_group                    = true
    multi_az_enabled                    = true
    automatic_failover_enabled          = true 
    cluster_az_ids                      = ["us-east-1a","us-east-1b"]
    #SG vars
    vpc_id_for_sg                       = "vpc-60714d06"
    use_existing_security_groups        = false
    allowed_cidr_blocks                 = ["10.114.54.89/32","10.114.32.0/24","10.114.33.0/24","10.114.34.0/24","10.114.35.0/24","10.114.36.0/24","100.65.0.0/16"]
    providers = {
    aws.awscaller_account               = aws.awscaller_account
  }
}