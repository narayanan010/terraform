resource "aws_security_group" "elastic_cloud_endpoint" {
  name_prefix = "elastic-cloud-endpoint-sg-"
  description = "Allow traffic to elastic cloud vpc endpoint"
  vpc_id      = data.aws_vpc.main.id
}

resource "aws_security_group_rule" "elastic-tls" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [ for a in data.aws_vpc.main.cidr_block_associations : a.cidr_block ]
  security_group_id = aws_security_group.elastic_cloud_endpoint.id
}

resource "aws_security_group_rule" "elastic-proxy-12300" {
  type              = "ingress"
  from_port         = 12300
  to_port           = 12300
  protocol          = "tcp"
  cidr_blocks       = [ for a in data.aws_vpc.main.cidr_block_associations : a.cidr_block ]
  security_group_id = aws_security_group.elastic_cloud_endpoint.id
}

resource "aws_security_group_rule" "elastic-proxy-12343" {
  type              = "ingress"
  from_port         = 12343
  to_port           = 12343
  protocol          = "tcp"
  cidr_blocks       = [ for a in data.aws_vpc.main.cidr_block_associations : a.cidr_block ]
  security_group_id = aws_security_group.elastic_cloud_endpoint.id
}

resource "aws_security_group_rule" "elastic-proxy-12400" {
  type              = "ingress"
  from_port         = 12400
  to_port           = 12400
  protocol          = "tcp"
  cidr_blocks       = [ for a in data.aws_vpc.main.cidr_block_associations : a.cidr_block ]
  security_group_id = aws_security_group.elastic_cloud_endpoint.id
}

resource "aws_security_group_rule" "elastic-proxy-12443" {
  type              = "ingress"
  from_port         = 12443
  to_port           = 12443
  protocol          = "tcp"
  cidr_blocks       = [ for a in data.aws_vpc.main.cidr_block_associations : a.cidr_block ]
  security_group_id = aws_security_group.elastic_cloud_endpoint.id
}

resource "aws_security_group_rule" "elastic-proxy-9200" {
  type              = "ingress"
  from_port         = 9200
  to_port           = 9200
  protocol          = "tcp"
  cidr_blocks       = [ for a in data.aws_vpc.main.cidr_block_associations : a.cidr_block ]
  security_group_id = aws_security_group.elastic_cloud_endpoint.id
}

resource "aws_security_group_rule" "elastic-proxy-9243" {
  type              = "ingress"
  from_port         = 9243
  to_port           = 9243
  protocol          = "tcp"
  cidr_blocks       = [ for a in data.aws_vpc.main.cidr_block_associations : a.cidr_block ]
  security_group_id = aws_security_group.elastic_cloud_endpoint.id
}

resource "aws_security_group_rule" "elastic-proxy-9300" {
  type              = "ingress"
  from_port         = 9300
  to_port           = 9300
  protocol          = "tcp"
  cidr_blocks       = [ for a in data.aws_vpc.main.cidr_block_associations : a.cidr_block ]
#   ipv6_cidr_blocks  = [data.aws_vpc.main.ipv6_cidr_block]
  security_group_id = aws_security_group.elastic_cloud_endpoint.id
}

resource "aws_security_group_rule" "elastic-proxy-9343" {
  type              = "ingress"
  from_port         = 9343
  to_port           = 9343
  protocol          = "tcp"
  cidr_blocks       = [ for a in data.aws_vpc.main.cidr_block_associations : a.cidr_block ]
  security_group_id = aws_security_group.elastic_cloud_endpoint.id
}
