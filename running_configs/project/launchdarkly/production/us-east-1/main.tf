module "aws_redis_module" {
    depends_on                           = [
      aws_security_group.ld-relay-proxy-sg
    ]
    source                               = "git@github.com:capterra/terraform.git//modules/elasticache/redis?ref=module_redis-v1.2.0"
    #Elasticache vars
    cluster_mode_enabled                 = false
    region                               = "us-east-1"
    cluster_id                           = "launchdarkly-prod-redis"
    engine                               = "redis"
    node_type                            = "cache.m5.xlarge"
    engine_version                       = "6.2"
    parameter_group_name                 = "default.redis6.x" 
    port                                 = "6379"
    subnet_list_to_add_to_subnet_group   = ["subnet-0231e00693814e9ae","subnet-0eb21cf804e8ae49f","subnet-05d54ce5511ff83cc"]
    maintenance_window                   = "sat:03:30-sun:01:00"
    snapshot_retention_limit             = 3
    snapshot_window                      = "01:30-03:20"
    multi_az_enabled                     = true
    cluster_size                         = "3"
    add_cluster_azs                      = true
    cluster_az_ids                       = ["us-east-1a","us-east-1b","us-east-1d"]
    transit_encryption_enabled           = true
    at_rest_encryption_enabled           = true
    add_subnet_group                     = true
    automatic_failover_enabled           = true
    #SG vars
    vpc_id_for_sg                        = "vpc-0e9d1ca8ead4977da"
    use_existing_security_groups         = false
    allowed_cidr_blocks                  = ["10.114.54.89/32", "10.114.55.48/32", "10.114.54.60/32", "10.114.55.70/32", "10.114.24.0/24", "10.114.25.0/24", "10.114.29.0/24"]
    allowed_security_groups              = ["sg-0fae991d536e869d9",aws_security_group.ld-relay-proxy-sg.id]
    providers                            = {
    aws.awscaller_account                = aws.awscaller_account
  }
}