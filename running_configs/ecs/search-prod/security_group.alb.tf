resource "aws_security_group" "security_group_alb" {
  name        = "${local.services_name}_alb"
  description = "accept only HTTP connections from the internet and can have all traffic out"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${local.services_name}_alb"
  }
}

resource "aws_security_group_rule" "ingress_alb_sg01" {
  type              = "ingress"
  description       = "Allow HTTP connections from the internet"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  security_group_id = aws_security_group.security_group_alb.id
}

resource "aws_security_group_rule" "ingress_alb_sg02" {
  type              = "ingress"
  description       = "Allow HTTPS connections from the internet"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  security_group_id = aws_security_group.security_group_alb.id
}

resource "aws_security_group_rule" "egress_alb_sg01" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  security_group_id = aws_security_group.security_group_alb.id
}
