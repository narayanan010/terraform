#*************************************************************************************************************************************************************#
#                                                                   Parameter Group         	                                                                #
#*************************************************************************************************************************************************************#

resource "aws_rds_cluster_parameter_group" "primary" {
  provider    = aws.primary
  family      = var.param_family
  name_prefix = "${var.vertical}-${var.application}-${var.environment}-"
  description = "primary cluster parameter group"
  # tags = merge(module.tags_resource_module.tags, tomap({
  #   "region" = data.aws_region.primary_current.name
  # }))
  tags = {
    "region" = data.aws_region.primary_current.name
  }
}

resource "aws_db_parameter_group" "primary" {
  provider    = aws.primary
  family      = var.param_family
  name_prefix = "${var.vertical}-${var.application}-${var.environment}-"
  description = "primary db parameter group"
  # tags = merge(module.tags_resource_module.tags, tomap({
  #   "region" = data.aws_region.primary_current.name
  # }))
  tags = {
    "region" = data.aws_region.primary_current.name
  }
}
