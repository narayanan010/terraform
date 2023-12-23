#*************************************************************************************************************************************************************#
#                                                    Aurora Global RDS cluster (parent)     	                                                                #
#*************************************************************************************************************************************************************#

resource "aws_rds_global_cluster" "main" {
  provider                  = aws.primary
  engine                    = var.engine
  engine_version            = var.engine_version
  global_cluster_identifier = "${var.vertical}-global-${var.application}-${var.environment}"
  storage_encrypted         = var.storage_encrypted
  lifecycle {
    ignore_changes = [database_name]
  }
}

#*************************************************************************************************************************************************************#
#                                                    1st region RDS cluster (primary)     	                                                                #
#*************************************************************************************************************************************************************#

resource "aws_rds_cluster" "primary" {
  provider                        = aws.primary
  global_cluster_identifier       = aws_rds_global_cluster.main.id
  cluster_identifier_prefix       = "${var.vertical}-${var.application}-${var.environment}-"
  db_subnet_group_name            = aws_db_subnet_group.primary.name
  engine_mode                     = var.engine_mode
  engine                          = var.engine
  engine_version                  = var.engine_version
  kms_key_id                      = var.primary_kms_arn == "" ? aws_kms_key.primary_kms_key_aws[0].arn : var.primary_kms_arn
  master_username                 = jsondecode(aws_secretsmanager_secret_version.rds.secret_string)["username"]
  master_password                 = jsondecode(aws_secretsmanager_secret_version.rds.secret_string)["password"]
  storage_encrypted               = var.storage_encrypted
  backup_retention_period         = var.backup_retention_period
  vpc_security_group_ids          = [aws_security_group.primary_sg.id]
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.primary.name
  skip_final_snapshot             = var.skip_final_snapshot
  database_name                   = var.database_name
  # tags = merge(module.tags_resource_module.tags, tomap({
  #   "region" = data.aws_region.primary_current.name
  # }))
  tags = {
    "region" = data.aws_region.primary_current.name
  }
}

resource "aws_rds_cluster_instance" "primary" {
  depends_on = [
    aws_rds_cluster.primary
  ]
  provider                     = aws.primary
  count                        = var.primary_cluster_instance_count
  identifier                   = "${var.vertical}-${var.application}-${var.environment}-instance-${count.index + 1}"
  cluster_identifier           = aws_rds_cluster.primary.id
  engine                       = var.engine
  engine_version               = var.engine_version
  db_subnet_group_name         = aws_db_subnet_group.primary.name
  db_parameter_group_name      = aws_db_parameter_group.primary.name
  performance_insights_enabled = var.performance_insights_enabled
  instance_class               = var.primary_instance_class
  # tags = merge(module.tags_resource_module.tags, tomap({
  #   "region" = data.aws_region.primary_current.name
  # }))
  tags = {
    "region" = data.aws_region.primary_current.name
  }
}

#*************************************************************************************************************************************************************#
#                                                    2nd region RDS cluster (secondary)   	                                                                #
#*************************************************************************************************************************************************************#

resource "aws_rds_cluster" "secondary" {
  depends_on                = [aws_rds_cluster_instance.primary]
  provider                  = aws.secondary
  global_cluster_identifier = aws_rds_global_cluster.main.id
  cluster_identifier_prefix = "${var.vertical}-${var.application}-${var.environment}-"
  db_subnet_group_name      = aws_db_subnet_group.secondary.name
  engine_mode               = var.engine_mode
  engine                    = var.engine
  engine_version            = var.engine_version
  kms_key_id                = var.secondary_kms_arn == "" ? aws_kms_key.secondary_kms_key_aws[0].arn : var.secondary_kms_arn
  source_region             = data.aws_region.primary_current.name
  storage_encrypted         = var.storage_encrypted
  backup_retention_period   = var.backup_retention_period
  skip_final_snapshot       = var.skip_final_snapshot
  # tags = merge(module.tags_resource_module.tags, tomap({
  #   "region" = data.aws_region.secondary_current.name
  # }))
  tags = {
    "region" = data.aws_region.secondary_current.name
  }
}

resource "aws_rds_cluster_instance" "secondary" {
  depends_on = [
    aws_rds_cluster.secondary
  ]
  provider             = aws.secondary
  count                = var.secondary_cluster_instance_count
  identifier           = "${var.vertical}-${var.application}-${var.environment}-instance-${count.index + 1}"
  cluster_identifier   = aws_rds_cluster.secondary.id
  engine               = var.engine
  engine_version       = var.engine_version
  db_subnet_group_name = aws_db_subnet_group.secondary.name
  instance_class       = var.secondary_instance_class
  # tags = merge(module.tags_resource_module.tags, tomap({
  #   "region" = data.aws_region.secondary_current.name
  # }))
  tags = {
    "region" = data.aws_region.secondary_current.name
  }
}
