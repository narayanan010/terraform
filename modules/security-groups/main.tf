terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.20.0"
    }
  }
  required_version = ">= 1.1.0"
}

# Security Group

resource "aws_security_group" "sec_grp" {
  count       = var.create_sg ? 1 : 0
  provider    = aws
  name        = lookup(var.sec_grp_names[count.index], "name", null)
  vpc_id      = lookup(var.sec_grp_names[count.index], "vpc_id", null)
  description = lookup(var.sec_grp_names[count.index], "description", null)
  lifecycle {
    create_before_destroy = true
  }
}

# Security Group Ingress Rules

resource "aws_security_group_rule" "sg_ingress_cidr" {
  count             = var.create_sg_ingress_cidr ? length(var.sg_ingress_rules_cidr) : 0
  provider          = aws
  type              = "ingress"
  to_port           = lookup(var.sg_ingress_rules_cidr[count.index], "to_port", null)
  protocol          = lookup(var.sg_ingress_rules_cidr[count.index], "protocol", null)
  from_port         = lookup(var.sg_ingress_rules_cidr[count.index], "from_port", null)
  cidr_blocks       = lookup(var.sg_ingress_rules_cidr[count.index], "cidr_blocks", null)
  ipv6_cidr_blocks  = lookup(var.sg_ingress_rules_cidr[count.index], "ipv6_cidr_blocks", null)
  description       = lookup(var.sg_ingress_rules_cidr[count.index], "description", null)
  security_group_id = aws_security_group.sec_grp[0].id
  depends_on = [
    aws_security_group.sec_grp
  ]
}

resource "aws_security_group_rule" "sg_ingress_rules_source_sg" {
  count                    = var.create_sg_ingress_source_sg ? length(var.sg_ingress_rules_source_sg) : 0
  provider                 = aws
  type                     = "ingress"
  to_port                  = lookup(var.sg_ingress_rules_source_sg[count.index], "to_port", null)
  protocol                 = lookup(var.sg_ingress_rules_source_sg[count.index], "protocol", null)
  from_port                = lookup(var.sg_ingress_rules_source_sg[count.index], "from_port", null)
  source_security_group_id = lookup(var.sg_ingress_rules_source_sg[count.index], "source_sg_id", null)
  description              = lookup(var.sg_ingress_rules_source_sg[count.index], "description", null)
  security_group_id        = aws_security_group.sec_grp[0].id
  depends_on = [
    aws_security_group.sec_grp
  ]
}

resource "aws_security_group_rule" "sg_ingress_rules_self" {
  count             = var.create_sg_ingress_self ? length(var.sg_ingress_rules_self) : 0
  provider          = aws
  type              = "ingress"
  to_port           = lookup(var.sg_ingress_rules_self[count.index], "to_port", null)
  protocol          = lookup(var.sg_ingress_rules_self[count.index], "protocol", null)
  from_port         = lookup(var.sg_ingress_rules_self[count.index], "from_port", null)
  self              = lookup(var.sg_ingress_rules_self[count.index], "self", null)
  description       = lookup(var.sg_ingress_rules_self[count.index], "description", null)
  security_group_id = aws_security_group.sec_grp[0].id
  depends_on = [
    aws_security_group.sec_grp
  ]
}

# Security Group Egress Rules

resource "aws_security_group_rule" "sg_egress_cidr" {
  count             = var.create_sg_egress_cidr ? length(var.sg_egress_rules_cidr) : 0
  provider          = aws
  type              = "egress"
  to_port           = lookup(var.sg_egress_rules_cidr[count.index], "to_port", null)
  protocol          = lookup(var.sg_egress_rules_cidr[count.index], "protocol", null)
  from_port         = lookup(var.sg_egress_rules_cidr[count.index], "from_port", null)
  cidr_blocks       = lookup(var.sg_egress_rules_cidr[count.index], "cidr_blocks", null)
  ipv6_cidr_blocks  = lookup(var.sg_egress_rules_cidr[count.index], "ipv6_cidr_blocks", null)
  description       = lookup(var.sg_egress_rules_cidr[count.index], "description", null)
  security_group_id = aws_security_group.sec_grp[0].id
  depends_on = [
    aws_security_group.sec_grp
  ]
}

resource "aws_security_group_rule" "sg_egress_rules_source_sg" {
  count                    = var.create_sg_egress_source_sg ? length(var.sg_egress_rules_source_sg) : 0
  provider                 = aws
  type                     = "egress"
  to_port                  = lookup(var.sg_egress_rules_source_sg[count.index], "to_port", null)
  protocol                 = lookup(var.sg_egress_rules_source_sg[count.index], "protocol", null)
  from_port                = lookup(var.sg_egress_rules_source_sg[count.index], "from_port", null)
  source_security_group_id = lookup(var.sg_egress_rules_source_sg[count.index], "source_sg_id", null)
  description              = lookup(var.sg_egress_rules_source_sg[count.index], "description", null)
  security_group_id        = aws_security_group.sec_grp[0].id
  depends_on = [
    aws_security_group.sec_grp
  ]
}

resource "aws_security_group_rule" "sg_egress_rules_self" {
  count             = var.create_sg_egress_self ? length(var.sg_egress_rules_self) : 0
  provider          = aws
  type              = "egress"
  to_port           = lookup(var.sg_egress_rules_self[count.index], "to_port", null)
  protocol          = lookup(var.sg_egress_rules_self[count.index], "protocol", null)
  from_port         = lookup(var.sg_egress_rules_self[count.index], "from_port", null)
  self              = lookup(var.sg_egress_rules_self[count.index], "self", null)
  description       = lookup(var.sg_egress_rules_self[count.index], "description", null)
  security_group_id = aws_security_group.sec_grp[0].id
  depends_on = [
    aws_security_group.sec_grp
  ]
}
