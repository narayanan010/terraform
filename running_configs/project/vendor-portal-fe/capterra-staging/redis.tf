module "aws_redis_module" {
  #source = "git@github.com:capterra/terraform.git//modules/elasticache/redis?ref=module_redis-v1.1.1"
  source = "../../../../modules/elasticache/redis"

  # Elasticache vars
  cluster_mode_enabled                 = true
  region                               = var.modulecaller_source_region
  cluster_id                           = "${var.tag_application}-${var.tag_environment}-redis"
  cluster_mode_replicas_per_node_group = 1
  engine_version                       = "7.0"
  parameter_group_name                 = "default.redis7"
  node_type                            = "cache.t4g.micro"
  cluster_size                         = 1
  transit_encryption_enabled           = true
  at_rest_encryption_enabled           = true

  # Maintenance
  maintenance_window       = "sat:05:00-sun:03:00"
  snapshot_retention_limit = 2
  snapshot_window          = "03:30-04:30"

  # Network
  vpc_id_for_sg                      = "vpc-60714d06"
  subnet_list_to_add_to_subnet_group = ["subnet-69726f44", "subnet-6514d82d"]
  add_subnet_group                   = true
  use_existing_security_groups       = false
  allowed_cidr_blocks                = ["10.114.32.0/24", "10.114.39.0/24"]
  port                               = 6379
}