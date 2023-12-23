# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform
resource "aws_elasticache_replication_group" "bidding_staging_redis" {
  apply_immediately           = null
  at_rest_encryption_enabled  = true
  auth_token                  = null # sensitive
  auto_minor_version_upgrade  = "true"
  automatic_failover_enabled  = true
  data_tiering_enabled        = false
  description                 = "This is Replication Group for bidding-staging"
  engine                      = "redis"
  engine_version              = "5.0.6"
  final_snapshot_identifier   = null
  global_replication_group_id = null
  kms_key_id                  = "arn:aws:kms:us-east-1:176540105868:key/fb078e93-bf93-4bc4-b7fe-f991f2fe4496"
  maintenance_window          = "sat:03:30-sun:01:00"
  multi_az_enabled            = false
  node_type                   = "cache.t3.micro"
  notification_topic_arn      = null
  num_node_groups             = 1
  parameter_group_name        = "default.redis5.0.cluster.on"
  port                        = 6379
  preferred_cache_cluster_azs = null
  replicas_per_node_group     = 1
  replication_group_id        = "bidding-staging"
  security_group_ids          = ["sg-0b57b874538e736a5"]
  security_group_names        = null
  snapshot_arns               = null
  snapshot_name               = null
  snapshot_retention_limit    = 3
  snapshot_window             = "01:30-03:20"
  subnet_group_name           = "tf-subnetgroup-bidding-staging"
  tags = {
    app_component       = "redis"
    app_contacts        = "capterra-devops"
    app_environment     = "staging"
    application         = "bidding"
    business_unit       = "GDM"
    created_by          = "sarvesh.gupta@gartner.com"
    environment         = "staging"
    function            = "cache"
    group               = "replication-group"
    monitoring          = "no"
    network_environment = "staging"
    product             = "VP"
    region              = "us-east-1"
    system_risk_class   = "3"
    terraform_managed   = "true"
    vertical            = "capterra"
  }
  tags_all = {
    app_component       = "redis"
    app_contacts        = "capterra-devops"
    app_environment     = "staging"
    application         = "bidding"
    business_unit       = "GDM"
    created_by          = "sarvesh.gupta@gartner.com"
    environment         = "staging"
    function            = "cache"
    group               = "replication-group"
    monitoring          = "no"
    network_environment = "staging"
    product             = "VP"
    region              = "us-east-1"
    system_risk_class   = "3"
    terraform_managed   = "true"
    vertical            = "capterra"
  }
  transit_encryption_enabled = true
  user_group_ids             = []
  lifecycle {
    ignore_changes = [security_group_names]
  }
}
