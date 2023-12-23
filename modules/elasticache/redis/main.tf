data "aws_caller_identity" "current" {
}
data "aws_availability_zones" "available" {
}

locals {
  cluster_size  = var.cluster_size > 1 ? var.cluster_size : 1
  cluster_id    = lower(var.cluster_id)
  restriction01 = var.node_type == "cache.t1.micro" && var.snapshot_retention_limit > 0 ? false : true
}

module "validation" {
  source = "./validation"
  
  validation = local.restriction01
}

######################################################
##  Security Group Resources
######################################################
resource "aws_security_group" "default" {
  count                       = var.use_existing_security_groups == false ? 1 : 0
  vpc_id                      = var.vpc_id_for_sg
  name                        = "tf-sg-${local.cluster_id}"
  tags                        = { "Name" = "tf-sg-${local.cluster_id}" }
}

resource "aws_security_group_rule" "egress" {
  count                       = var.use_existing_security_groups == false ? 1 : 0
  description                 = "Allow all egress traffic"
  from_port                   = 0
  to_port                     = 0
  protocol                    = -1
  cidr_blocks                 = ["0.0.0.0/0"]
  security_group_id           = join("", aws_security_group.default.*.id)
  type                        = "egress"
}

resource "aws_security_group_rule" "ingress_security_groups" {
  count                       = var.use_existing_security_groups == false ? length(var.allowed_security_groups) : 0
  description                 = "Allow inbound traffic from existing Security Groups"
  from_port                   = var.port
  to_port                     = var.port
  protocol                    = "tcp"
  source_security_group_id    = var.allowed_security_groups[count.index]
  security_group_id           = join("", aws_security_group.default.*.id)
  type                        = "ingress"
}

resource "aws_security_group_rule" "ingress_cidr_blocks" {
  count                       = var.use_existing_security_groups == false && length(var.allowed_cidr_blocks) > 0 ? 1 : 0
  description                 = "Allow inbound traffic from CIDR blocks"
  from_port                   = var.port
  to_port                     = var.port
  protocol                    = "tcp"
  cidr_blocks                 = var.allowed_cidr_blocks
  security_group_id           = join("", aws_security_group.default.*.id)
  type                        = "ingress"
}

resource "aws_security_group_rule" "ingress_prefix_list" {
  count                       = length(var.allowed_prefix_list) > 0 ? 1 : 0
  description                 = "Allow inbound traffic from prefix list"
  from_port                   = var.port
  to_port                     = var.port
  protocol                    = "tcp"
  prefix_list_ids             = var.allowed_prefix_list
  security_group_id           = join("", aws_security_group.default.*.id)
  type                        = "ingress"
}



######################################################
##  Elasticache Cluster Resources
######################################################

resource "aws_elasticache_subnet_group" "ec_cluster_subnet_group" {
  count                       = var.add_subnet_group && var.elasticache_existing_subnet_group_name == "" && length(var.subnet_list_to_add_to_subnet_group) > 0 ? 1 : 0

  name                        = "tf-subnetgroup-${local.cluster_id}"
  description                 = "Subnet group for ${local.cluster_id}"
  subnet_ids                  = var.subnet_list_to_add_to_subnet_group
}

resource "aws_elasticache_replication_group" "ec_cluster_replication_gp" {
  replication_group_id        = local.cluster_id
  description                 = "This is Replication Group for ${local.cluster_id}"
  node_type                   = var.node_type
  parameter_group_name        = var.parameter_group_name
  port                        = var.port
  maintenance_window          = var.maintenance_window
  snapshot_retention_limit    = var.snapshot_retention_limit
  snapshot_window             = var.snapshot_window
  transit_encryption_enabled  = var.transit_encryption_enabled
  auth_token                  = var.transit_encryption_enabled ? aws_ssm_parameter.redis_random_pwd.value : null
  at_rest_encryption_enabled  = var.at_rest_encryption_enabled
  kms_key_id                  = var.at_rest_encryption_enabled ? aws_kms_key.akk[0].arn : null
  engine                      = var.engine
  engine_version              = var.engine_version
  subnet_group_name           = var.add_subnet_group && var.elasticache_existing_subnet_group_name == "" ? aws_elasticache_subnet_group.ec_cluster_subnet_group[0].name : var.elasticache_existing_subnet_group_name
  security_group_ids          = var.use_existing_security_groups ? var.existing_security_groups : [join("", aws_security_group.default.*.id)]

  num_cache_clusters          = var.cluster_mode_enabled ? null : local.cluster_size
  automatic_failover_enabled  = var.cluster_mode_enabled ? true : var.automatic_failover_enabled
  multi_az_enabled            = var.multi_az_enabled
  preferred_cache_cluster_azs = length(var.cluster_az_ids) > 1 ? var.cluster_az_ids : var.cluster_mode_enabled == true ? null : local.cluster_size == 1 ? [data.aws_availability_zones.available.names[0]] : [for n in range(0, local.cluster_size) : element([data.aws_availability_zones.available.names[n]], n)]

  lifecycle {
    ignore_changes = [num_cache_clusters]
  }

  replicas_per_node_group     = var.cluster_mode_enabled ? var.cluster_mode_replicas_per_node_group : null
  num_node_groups             = var.cluster_mode_enabled ? var.cluster_mode_num_node_groups : null

  tags = { "group" = "replication-group" }
  depends_on = [aws_kms_key.akk]
}

######################################################
##  KMS CMK for bucket
######################################################

resource "aws_kms_key" "akk" {
  provider = aws.untagged
  count                   = var.at_rest_encryption_enabled == true ? 1 : 0

  description             = "This key is used in encryption at rest for Elasticache Redis Cluster ${local.cluster_id}"
  deletion_window_in_days = 8
  is_enabled              = true
  enable_key_rotation     = var.enable_kms_key_rotation
  bypass_policy_lockout_safety_check = false
  policy                  =  jsonencode(
    {
        "Version": "2012-10-17",
        "Id": "key-default-1",
        "Statement": [{
          "Sid": "Enable IAM User Permissions",
          "Effect": "Allow",
          "Principal": {
            "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
          },
          "Action": [
            "kms:*"
          ],
          "Resource": "*"
        }]
    }
  )

  timeouts {
    create = "3m"
  }
}

resource "aws_kms_alias" "aka" {
  count         = var.at_rest_encryption_enabled == true ? 1 : 0

  name          = "alias/${aws_elasticache_replication_group.ec_cluster_replication_gp.id}"
  target_key_id = aws_kms_key.akk[count.index].key_id
}


######################################################
##  Random resource for Redis password
######################################################
resource "random_string" "random_string" {
  length           = 17
  special          = true
  override_special = "(){}"
}

resource "aws_ssm_parameter" "redis_random_pwd" {
  name     = "redis_random_name-${local.cluster_id}"
  type     = "SecureString"
  value    = random_string.random_string.result

  tags = { "group" = "ssm-param-group" }
}
