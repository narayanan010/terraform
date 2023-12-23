module "RDS" {
  source = "../../../modules/RDS"

  # Common
  vertical    = var.vertical
  environment = var.environment
  application = var.application

  # Database
  database_name                = var.database_name
  engine                       = var.engine
  engine_mode                  = var.engine_mode
  engine_version               = var.engine_version
  primary_instance_class       = var.primary_instance_class
  secondary_instance_class     = var.secondary_instance_class
  performance_insights_enabled = var.performance_insights_enabled

  # Storage & Backup
  storage_encrypted       = var.storage_encrypted
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot

  # Subnet Groups
  primary_subnet_ids   = var.primary_subnet_ids
  secondary_subnet_ids = var.secondary_subnet_ids

  # Primary
  primary_cluster_instance_count = var.primary_cluster_instance_count
  primary_kms_arn                = var.primary_kms_arn

  # Secondary
  secondary_cluster_instance_count = var.secondary_cluster_instance_count
  secondary_kms_arn                = var.secondary_kms_arn

  # Security groups
  primary_vpc_id                      = var.primary_vpc_id
  secondary_vpc_id                    = var.secondary_vpc_id
  primary_security_group_ingress_rule = var.primary_security_group_ingress_rule

  secondary_security_group_ingress_rule = var.secondary_security_group_ingress_rule

  providers = {
    aws.primary   = aws.primary
    aws.secondary = aws.secondary
  }
}
