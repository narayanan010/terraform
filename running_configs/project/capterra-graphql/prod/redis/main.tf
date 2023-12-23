module "aws_redis_module" {
  source = "git@github.com:capterra/terraform.git//modules/elasticache/redis?ref=module_redis-v1.2.0"

  #Elasticache vars
  cluster_mode_enabled               = false
  region                             = "us-east-1"
  cluster_id                         = "capterra-graphql-prod-redis-cluster"
  node_type                          = "cache.m5.large"
  engine_version                     = "7.0"
  parameter_group_name               = "default.redis7"
  port                               = "6379"
  subnet_list_to_add_to_subnet_group = ["subnet-87666faa", "subnet-1529d05d", "subnet-082cd9abed1c1291f"]
  maintenance_window                 = "sat:05:00-sun:03:00"
  snapshot_retention_limit           = 3
  snapshot_window                    = "03:30-04:30"
  cluster_size                       = "2"
  transit_encryption_enabled         = true
  at_rest_encryption_enabled         = true
  add_subnet_group                   = true
  multi_az_enabled                   = true
  automatic_failover_enabled         = true
  #SG vars
  vpc_id_for_sg                = "vpc-c2ecc1a4"
  use_existing_security_groups = false
  allowed_cidr_blocks          = ["10.114.24.0/21", "10.114.80.0/28"]

  providers = {
    aws.awscaller_account = aws.awscaller_account
  }
}