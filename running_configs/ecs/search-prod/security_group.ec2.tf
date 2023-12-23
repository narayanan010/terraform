resource "aws_security_group" "security_group_ec2" {
  name        = "${local.services_name}_ec2"
  description = "Allows EC2 instances to communicate with the ECS cluster"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${local.services_name}_ec2"
  }
}

resource "aws_security_group_rule" "ingress_ec2_sg01" {
  type                     = "ingress"
  description              = ""
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.security_group_alb.id
  prefix_list_ids          = []
  security_group_id        = aws_security_group.security_group_ec2.id
}

resource "aws_security_group_rule" "egress_ec2_sg01" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  security_group_id = aws_security_group.security_group_ec2.id
}
