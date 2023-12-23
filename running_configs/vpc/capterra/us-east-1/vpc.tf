
data "aws_vpcs" "region_us-east-1" {}

data "aws_vpc" "region_us-east-1" {
  count = length(data.aws_vpcs.region_us-east-1.ids)
  id    = tolist(data.aws_vpcs.region_us-east-1.ids)[count.index]
}

resource "aws_flow_log" "region_us-east-1" {
  count = length(data.aws_vpcs.region_us-east-1.ids)

  iam_role_arn    = aws_iam_role.vpc_cw_logs_role.arn
  log_destination = aws_cloudwatch_log_group.region_us-east-1[count.index].arn
  traffic_type    = "ALL"
  vpc_id = data.aws_vpcs.region_us-east-1.ids[count.index]
  max_aggregation_interval = 600
}


resource "aws_cloudwatch_log_group" "region_us-east-1" {
  count = length(data.aws_vpcs.region_us-east-1.ids)

  name              = "${var.cw_prefix}${data.aws_vpcs.region_us-east-1.ids[count.index]}"
  retention_in_days = var.cw_logs_retention
}

