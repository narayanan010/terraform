module "aws_redis_module" {
    source                               = "git@github.com:capterra/terraform.git//modules/elasticache/redis?ref=module_redis-v1.2.0"
    #Elasticache vars
    cluster_mode_enabled                 = false
    region                               = "us-west-2"
    cluster_id                           = "compare-ui-production-dr-redis"
    engine                               = "redis"
    node_type                            = "cache.m5.xlarge"
    engine_version                       = "7.0"
    parameter_group_name                 = "default.redis7" 
    port                                 = "6379"
    subnet_list_to_add_to_subnet_group   = ["subnet-06b11e1f55980a35c","subnet-0b575f7aa82e4d0f2"]
    maintenance_window                   = "sat:03:30-sun:01:00"
    snapshot_retention_limit             = 3
    snapshot_window                      = "01:30-03:20"
    multi_az_enabled                     = true
    cluster_size                         = "2"
    add_cluster_azs                      = true
    cluster_az_ids                       = ["us-west-2b","us-west-2a"]
    transit_encryption_enabled           = true
    at_rest_encryption_enabled           = true
    add_subnet_group                     = true
    automatic_failover_enabled           = true
    #SG vars
    vpc_id_for_sg                        = "vpc-02f17c4cb074d6783"
    use_existing_security_groups         = true
    existing_security_groups             = ["sg-0a862dc46eb5e4d32"]
    allowed_cidr_blocks                  = ["10.114.24.0/21","10.114.56.29/32","10.114.144.0/21","10.114.56.0/21","10.114.24.128/32"]
    allowed_security_groups              = ["sg-0dd4f152464bb87bc"]
    providers                            = {
    aws.awscaller_account                = aws.awscaller_account
  }
}
