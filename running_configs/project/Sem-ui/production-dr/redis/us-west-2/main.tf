module "aws_redis_module" {
    #source                              = "git@github.com:capterra/terraform.git//modules/elasticache/redis"
    source                               = "../../../../../../modules/elasticache/redis/"
    #Elasticache vars
    cluster_mode_enabled                 = false
    region                               = "us-west-2"
    cluster_id                           = "sem-ui-production-dr-redis"
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
    existing_security_groups             = ["sg-0bc2a4832ef91d7b9"]
    providers                            = {
    aws.awscaller_account                = aws.awscaller_account
    aws.aws_sot_account                  = aws.aws_sot_account
  }
}
