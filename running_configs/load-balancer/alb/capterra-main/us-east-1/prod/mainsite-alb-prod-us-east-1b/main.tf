resource "aws_lb" "mainsite-alb-prod-us-east-1b" {
  provider  = aws
  access_logs {
    bucket  = "capterra-loadbalancer-logs"
    enabled = "true"
    prefix  = "mainsite-alb-prod-us-east-1b"
  }

  desync_mitigation_mode     = "defensive"
  drop_invalid_header_fields = "false"
  enable_deletion_protection = "true"
  enable_http2               = "true"
  enable_waf_fail_open       = "true"
  idle_timeout               = "60"
  internal                   = "false"
  ip_address_type            = "ipv4"
  load_balancer_type         = "application"
  name                       = "mainsite-alb-prod-us-east-1b"
  security_groups            = ["sg-0664e2cc5785ec11c"]

  subnet_mapping {
    subnet_id = "subnet-2f626b02"
  }

  subnet_mapping {
    subnet_id = "subnet-6c2cd524"
  }

  subnets = ["subnet-2f626b02", "subnet-6c2cd524"]
}
