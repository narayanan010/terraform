resource "aws_flow_log" "region_filter" {
  iam_role_arn    = aws_iam_role.vpc_cw_logs_role.arn
  log_destination = aws_cloudwatch_log_group.region_filter01.arn
  traffic_type    = "ALL"
  #vpc_id = module.aws_vpc_mod.vpc_id
  vpc_id = "vpc-0e6ebdba21adae23d"
  max_aggregation_interval = 600
}

resource "aws_cloudwatch_log_group" "region_filter01" {
  #name              = "${var.cw_prefix}${module.aws_vpc_mod.vpc_id}"
  name              = "${var.cw_prefix}/vpc-0e6ebdba21adae23d"
  retention_in_days = var.cw_logs_retention
}