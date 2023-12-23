resource "aws_security_group" "datadog_endpoint" {
  name_prefix = "datadog-endpoint-sg-"
  description = "Allow traffic to elastic cloud vpc endpoint"
  vpc_id      = data.aws_vpc.main.id
}

resource "aws_security_group_rule" "datadog-tls" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [ for a in data.aws_vpc.main.cidr_block_associations : a.cidr_block ]
  security_group_id = aws_security_group.datadog_endpoint.id
}

module "datadog-vpc-endpoints" {
  source = "git::ssh://git@github.com/capterra/terraform.git//modules/networking/vpc-endpoint"
  vpc_id = var.vpc_id
  interface_vpc_endpoints = {
    "datadog_agent_logs" = {
      name                = "com.amazonaws.vpce.us-east-1.vpce-svc-025a56b9187ac1f63"
      subnet_ids          = var.datadog_vpc_endpoint_subnet_ids
      policy              = null
      security_group_ids  = [aws_security_group.datadog_endpoint.id]
      private_dns_enabled = true
      application_tag     = "datadog-agent-logs"
    }
    "datadog_user_logs" = {
      name                = "com.amazonaws.vpce.us-east-1.vpce-svc-0e36256cb6172439d"
      subnet_ids          = var.datadog_vpc_endpoint_subnet_ids
      policy              = null
      security_group_ids  = [aws_security_group.datadog_endpoint.id]
      private_dns_enabled = true
      application_tag     = "datadog-user-logs"
    }
    "datadog_metrics" = {
      name                = "com.amazonaws.vpce.us-east-1.vpce-svc-09a8006e245d1e7b8"
      subnet_ids          = var.datadog_vpc_endpoint_subnet_ids
      policy              = null
      security_group_ids  = [aws_security_group.datadog_endpoint.id]
      private_dns_enabled = true
      application_tag     = "datadog-metrics"
    }
  }
}
