resource "aws_memorydb_subnet_group" "capterrasearchstagingmemorydbsubnetgroup" {
  name        = "capterrasearchstagingmemorydbsubnetgroup"
  description = ""
  subnet_ids  = ["subnet-089258bf9059259d3", "subnet-0272efa24d4855bfb", "subnet-09f42dd6431604575"]
}


resource "aws_memorydb_cluster" "click-streaming-staging-ue1" {
  name                   = var.memory_db_cluster_name
  description            = "Click-streaming"
  engine_version         = var.memory_db_engine_version
  node_type              = var.memory_db_node_type
  num_shards             = var.memory_db_num_shards
  num_replicas_per_shard = var.memory_db_num_replicas_per_shard

  acl_name           = aws_memorydb_acl.acl.name
  tls_enabled        = var.memory_db_tls_enabled
  security_group_ids = [aws_security_group.click_streaming_memorydb.id]
  subnet_group_name  = aws_memorydb_subnet_group.capterrasearchstagingmemorydbsubnetgroup.id

  maintenance_window       = var.memory_db_maintenance_window
  snapshot_window          = var.memory_db_snapshot_window
  snapshot_retention_limit = var.memory_db_snapshot_retention_limit

  timeouts {}
}


resource "aws_security_group" "click_streaming_memorydb" {
  name        = "ClickStreamingMemoryDB"
  description = "Click Streaming Memory DB"
  vpc_id      = "vpc-0715b585d83b5dac0"
}

resource "aws_security_group_rule" "click_streaming_memorydb_sgr01" {
  type              = "ingress"
  description       = "Custom TCP port"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  cidr_blocks       = ["10.114.32.70/32"]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  security_group_id = aws_security_group.click_streaming_memorydb.id
}

resource "aws_security_group_rule" "click_streaming_memorydb_sgr02" {
  type                     = "ingress"
  description              = "Lambda ENI"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.click_streaming_lambda.id
  security_group_id        = aws_security_group.click_streaming_memorydb.id
}

resource "aws_security_group_rule" "click_streaming_memorydb_sgr04" {
  type              = "ingress"
  description       = "RS1A Access"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  cidr_blocks       = ["10.114.32.120/32"]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  security_group_id = aws_security_group.click_streaming_memorydb.id
}

resource "aws_security_group_rule" "click_streaming_memorydb_sgr05" {
  type              = "ingress"
  description       = "RS1B Access"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  cidr_blocks       = ["10.114.33.118/32"]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  security_group_id = aws_security_group.click_streaming_memorydb.id
}

resource "aws_security_group_rule" "click_streaming_memorydb_sgr06" {
  type              = "ingress"
  description       = "Capterra-staging-Private-subnet-ranges"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  prefix_list_ids   = [aws_ec2_managed_prefix_list.capterra_staging_vpc_private.id]
  ipv6_cidr_blocks  = []
  security_group_id = aws_security_group.click_streaming_memorydb.id
}

resource "aws_security_group_rule" "click_streaming_memorydb_sgr03" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  security_group_id = aws_security_group.click_streaming_memorydb.id
}

resource "aws_memorydb_acl" "acl" {
  name       = "my-acl"
  user_names = [aws_memorydb_user.admin.user_name, aws_memorydb_user.lambda.user_name]
}

data "aws_ssm_parameter" "memorydb_user_admin_password" {
  name = "click_streaming_memorydb_users_admin_password"
}


data "aws_ssm_parameter" "memorydb_user_lambda_password" {
  name = "click_streaming_memorydb_users_lambda_password"
}


resource "aws_memorydb_user" "admin" {
  user_name     = "admin"
  access_string = "on ~* &* +@all"

  authentication_mode {
    type      = "password"
    passwords = [data.aws_ssm_parameter.memorydb_user_admin_password.value]
  }
}


resource "aws_memorydb_user" "lambda" {
  user_name     = "lambda"
  access_string = "on ~* &* -@all +@read +info +cluster +command +sadd +hset +copy +rename +select +del +set +expire +hdel +ping"

  authentication_mode {
    type      = "password"
    passwords = [data.aws_ssm_parameter.memorydb_user_lambda_password.value]
  }
}
