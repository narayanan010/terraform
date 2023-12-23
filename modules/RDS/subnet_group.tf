#*************************************************************************************************************************************************************#
#                                                               Subnet Group                	                                                                #
#*************************************************************************************************************************************************************#

resource "aws_db_subnet_group" "primary" {
  provider    = aws.primary
  name_prefix = "${var.vertical}-${var.application}-${var.environment}-"
  subnet_ids  = var.primary_subnet_ids
  # tags = merge(module.tags_resource_module.tags, tomap({
  #   "region" = data.aws_region.primary_current.name
  # }))
  tags = {
    "region" = data.aws_region.primary_current.name
  }
}

resource "aws_db_subnet_group" "secondary" {
  provider    = aws.secondary
  name_prefix = "${var.vertical}-${var.application}-${var.environment}-"
  subnet_ids  = var.secondary_subnet_ids
  # tags = merge(module.tags_resource_module.tags, tomap({
  #   "region" = data.aws_region.secondary_current.name
  # }))
  tags = {
    "region" = data.aws_region.secondary_current.name
  }
}
