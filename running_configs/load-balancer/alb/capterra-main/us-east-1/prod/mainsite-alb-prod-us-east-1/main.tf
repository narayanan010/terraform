resource "aws_lb" "mainsite-alb-prod-us-east-1" {
  access_logs {
    bucket  = "capterra-loadbalancer-logs"
    enabled = "true"
    prefix  = "mainsite-alb-prod-us-east-1"
  }

  desync_mitigation_mode     = "defensive"
  drop_invalid_header_fields = "false"
  enable_deletion_protection = "false"
  enable_http2               = "true"
  enable_waf_fail_open       = "true"
  idle_timeout               = "60"
  internal                   = "false"
  ip_address_type            = "ipv4"
  load_balancer_type         = "application"
  name                       = "mainsite-alb-prod-us-east-1"
  security_groups            = ["sg-0664e2cc5785ec11c"]

  subnet_mapping {
    subnet_id = "subnet-2f626b02"
  }

  subnet_mapping {
    subnet_id = "subnet-6c2cd524"
  }

  subnets = ["subnet-2f626b02", "subnet-6c2cd524"]

  tags = {
    Name = "mainsite-alb-prod-us-east-1a"
  }

  tags_all = {
    Name = "mainsite-alb-prod-us-east-1a"
  }
}
