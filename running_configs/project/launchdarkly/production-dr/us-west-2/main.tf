module "aws_redis_module" {
    depends_on                           = [
      aws_security_group.ld-relay-proxy-sg
    ]
    source                               = "git@github.com:capterra/terraform.git//modules/elasticache/redis?ref=module_redis-v1.2.0"
    #Elasticache vars
    cluster_mode_enabled                 = false
    region                               = "us-west-2"
    cluster_id                           = "launchdarkly-prod-dr-redis"
    engine                               = "redis"
    node_type                            = "cache.m5.xlarge"
    engine_version                       = "6.2"
    parameter_group_name                 = "default.redis6.x" 
    port                                 = "6379"
    subnet_list_to_add_to_subnet_group   = ["subnet-095309c0629cd20bf","subnet-08eb96f92f58c5aa5","subnet-0b575f7aa82e4d0f2"]
    maintenance_window                   = "sat:03:30-sun:01:00"
    snapshot_retention_limit             = 3
    snapshot_window                      = "01:30-03:20"
    multi_az_enabled                     = true
    cluster_size                         = "3"
    add_cluster_azs                      = true
    cluster_az_ids                       = ["us-west-2a","us-west-2b","us-west-2c"]
    transit_encryption_enabled           = true
    at_rest_encryption_enabled           = true
    add_subnet_group                     = true
    automatic_failover_enabled           = true
    #SG vars
    vpc_id_for_sg                        = "vpc-02f17c4cb074d6783"
    use_existing_security_groups         = false
    allowed_cidr_blocks                  = ["10.114.60.103/32"]
    allowed_security_groups              = ["sg-0dd4f152464bb87bc",aws_security_group.ld-relay-proxy-sg.id]
    providers                            = {
    aws.awscaller_account                = aws.awscaller_account
  }
}