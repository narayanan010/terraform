module "aws_redis_module" {
  source = "git@github.com:capterra/terraform.git//modules/elasticache/redis"
  #Elasticache vars
  cluster_mode_enabled               = false
  region                             = "us-west-2"
  cluster_id                         = "capterra-graphql-prod-dr-redis-cluster"
  node_type                          = "cache.t3.small"
  engine_version                     = "7.0"
  parameter_group_name               = "default.redis7"
  port                               = "6379"
  subnet_list_to_add_to_subnet_group = ["subnet-02393287a7560bdd9", "subnet-03c6c67c42e458e6a", "subnet-09777af13fed9be6e"]
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
  vpc_id_for_sg                = "vpc-01dd95434aa80f7a8"
  use_existing_security_groups = false
  allowed_security_groups      = ["sg-06e13bdcf818b964a"]
  allowed_cidr_blocks          = ["10.114.56.0/21"]
  providers = {
    aws.awscaller_account = aws.awscaller_account
  }
}