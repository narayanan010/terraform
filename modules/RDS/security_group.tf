#*************************************************************************************************************************************************************#
#                                                      			       Security Group     	                                                                    #
#*************************************************************************************************************************************************************#

resource "aws_security_group" "primary_sg" {
  provider    = aws.primary
  name_prefix = "rds-${var.environment}-${var.vertical}-${var.application}-"
  vpc_id      = var.primary_vpc_id

  dynamic "ingress" {
    for_each = var.primary_security_group_ingress_rule
    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      cidr_blocks     = ingress.value.cidr_blocks
      security_groups = ingress.value.sg_ids
      description     = ingress.value.description
    }
  }

  tags = {
    "region" = data.aws_region.primary_current.name
  }
}

resource "aws_security_group" "secondary_sg" {
  provider    = aws.secondary
  name_prefix = "rds-${var.environment}-${var.vertical}-${var.application}-"
  vpc_id      = var.secondary_vpc_id

  dynamic "ingress" {
    for_each = var.secondary_security_group_ingress_rule
    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      cidr_blocks     = ingress.value.cidr_blocks
      security_groups = ingress.value.sg_ids
      description     = ingress.value.description
    }
  }

  tags = {
    "region" = data.aws_region.secondary_current.name
  }
}