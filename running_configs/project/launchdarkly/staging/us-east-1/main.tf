module "aws_redis_module" {
    depends_on                           = [
      aws_security_group.ld-relay-proxy-sg
    ]
    source                               = "git@github.com:capterra/terraform.git//modules/elasticache/redis?ref=module_redis-v1.2.0"
    #Elasticache vars
    cluster_mode_enabled                 = false
    region                               = "us-east-1"
    cluster_id                           = "launchdarkly-staging-redis"
    engine                               = "redis"
    node_type                            = "cache.t3.medium"
    engine_version                       = "6.2"
    parameter_group_name                 = "default.redis6.x" 
    port                                 = "6379"
    subnet_list_to_add_to_subnet_group   = ["subnet-0272efa24d4855bfb","subnet-089258bf9059259d3"]
    maintenance_window                   = "sat:03:30-sun:01:00"
    snapshot_retention_limit             = 3
    snapshot_window                      = "01:30-03:20"
    multi_az_enabled                     = true
    cluster_size                         = "2"
    add_cluster_azs                      = true
    cluster_az_ids                       = ["us-east-1a","us-east-1c"]
    transit_encryption_enabled           = true
    at_rest_encryption_enabled           = true
    add_subnet_group                     = true
    automatic_failover_enabled           = true
    #SG vars
    vpc_id_for_sg                        = "vpc-0715b585d83b5dac0"
    use_existing_security_groups         = false
    allowed_cidr_blocks                  = ["10.114.54.89/32","10.114.32.0/24","10.114.33.0/24","10.114.34.0/24","10.114.35.0/24","10.114.36.0/24"]
    allowed_security_groups              = ["sg-03dc2808b9ca5f3a2",aws_security_group.ld-relay-proxy-sg.id]
    providers                            = {
    aws.awscaller_account                = aws.awscaller_account
  }
}