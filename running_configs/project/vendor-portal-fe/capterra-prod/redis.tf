module "aws_redis_module" {
  #source = "git@github.com:capterra/terraform.git//modules/elasticache/redis?ref=module_redis-v1.1.1"
  source = "../../../../modules/elasticache/redis"

  # Elasticache vars
  cluster_mode_enabled                 = true
  region                               = var.modulecaller_source_region
  cluster_id                           = "${var.tag_application}-${var.tag_environment}-redis"
  cluster_size                         = 2
  cluster_mode_replicas_per_node_group = 1
  engine_version                       = "7.0"
  parameter_group_name                 = "default.redis7.cluster.on"
  node_type                            = "cache.t4g.medium"
  transit_encryption_enabled           = true
  at_rest_encryption_enabled           = true

  # Maintenance
  maintenance_window       = "sat:05:00-sun:03:00"
  snapshot_retention_limit = 2
  snapshot_window          = "03:30-04:30"

  # Network
  vpc_id_for_sg                      = "vpc-c2ecc1a4"
  subnet_list_to_add_to_subnet_group = ["subnet-1529d05d", "subnet-082cd9abed1c1291f"]
  add_subnet_group                   = true
  use_existing_security_groups       = false
  allowed_cidr_blocks                = ["10.114.25.0/24", "10.114.29.0/24"]
  port                               = 6379

  providers = {
    aws.untagged = aws.untagged
  }
}