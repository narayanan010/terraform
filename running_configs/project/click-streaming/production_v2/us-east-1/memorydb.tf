resource "aws_memorydb_subnet_group" "capterrasearchproductionmemorydbsubnetgroup" {
  name        = "capterrasearchproductionmemorydbsubnetgroup"
  description = ""
  subnet_ids  = ["subnet-0eb21cf804e8ae49f", "subnet-05d54ce5511ff83cc", "subnet-0231e00693814e9ae"]
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
  subnet_group_name  = aws_memorydb_subnet_group.capterrasearchproductionmemorydbsubnetgroup.id

  maintenance_window       = var.memory_db_maintenance_window
  snapshot_window          = var.memory_db_snapshot_window
  snapshot_retention_limit = var.memory_db_snapshot_retention_limit
}


resource "aws_security_group" "click_streaming_memorydb" {
  name        = "ClickStreamingMemoryDB"
  description = "Click Streaming Memory DB"
  vpc_id      = "vpc-0e9d1ca8ead4977da"
}
resource "aws_security_group_rule" "click_streaming_memorydb_sgr01_ingress" {
  type                     = "ingress"
  description              = "Lambda ENI"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.click_streaming_lambda.id
  security_group_id        = aws_security_group.click_streaming_memorydb.id
}


resource "aws_security_group_rule" "click_streaming_memorydb_sgr02_ingress" {
  type              = "ingress"
  description       = "Bation paris"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  cidr_blocks       = ["10.114.97.23/32"]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  security_group_id = aws_security_group.click_streaming_memorydb.id
}

resource "aws_security_group_rule" "click_streaming_memorydb_sgr03_ingress" {
  type              = "ingress"
  description       = "Bastion us-east-1"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  cidr_blocks       = ["10.114.54.89/32"]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  security_group_id = aws_security_group.click_streaming_memorydb.id
}

resource "aws_security_group_rule" "click_streaming_memorydb_sgr04_ingress" {
  type              = "ingress"
  description       = "Jenkins"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  cidr_blocks       = ["10.114.54.209/32"]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  security_group_id = aws_security_group.click_streaming_memorydb.id
}

resource "aws_security_group_rule" "click_streaming_memorydb_sgr05_ingress" {
  type              = "ingress"
  description       = "cd1a"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  cidr_blocks       = ["10.114.24.128/32"]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  security_group_id = aws_security_group.click_streaming_memorydb.id
}

resource "aws_security_group_rule" "click_streaming_memorydb_sgr06_ingress" {
  type              = "ingress"
  description       = "logstash-prod"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  cidr_blocks       = ["10.114.24.11/32"]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  security_group_id = aws_security_group.click_streaming_memorydb.id
}

resource "aws_security_group_rule" "click_streaming_memorydb_sgr07_ingress" {
  type              = "ingress"
  description       = "MR1A"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  cidr_blocks       = ["10.114.24.132/32"]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  security_group_id = aws_security_group.click_streaming_memorydb.id
}

resource "aws_security_group_rule" "click_streaming_memorydb_sgr08_ingress" {
  type              = "ingress"
  description       = "MR1B"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  cidr_blocks       = ["10.114.25.231/32"]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  security_group_id = aws_security_group.click_streaming_memorydb.id
}

resource "aws_security_group_rule" "click_streaming_memorydb_sgr09_ingress" {
  type              = "ingress"
  description       = "logstash-prod-dr"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  cidr_blocks       = ["10.114.56.112/32"]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  security_group_id = aws_security_group.click_streaming_memorydb.id
}

resource "aws_security_group_rule" "click_streaming_memorydb_sgr10_ingress" {
  type              = "ingress"
  description       = "Capterra-prod-private-ranges"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  ipv6_cidr_blocks  = []
  prefix_list_ids   = [aws_ec2_managed_prefix_list.capterra_production_vpc_private.id]
  security_group_id = aws_security_group.click_streaming_memorydb.id
}

resource "aws_security_group_rule" "click_streaming_memorydb_sgr_egress" {
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
  user_name = "lambda"
  #access_string = "on ~* &* -@all +@read +info +cluster +command +sadd +hset"
  access_string = "on ~* &* -@all +@read +info +cluster +command +sadd +hset +copy +rename +select +del +set +expire +hdel +ping"

  authentication_mode {
    type      = "password"
    passwords = [data.aws_ssm_parameter.memorydb_user_lambda_password.value]
  }
}
