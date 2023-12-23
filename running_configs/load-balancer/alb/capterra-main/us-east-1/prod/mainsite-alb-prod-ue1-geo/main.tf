resource "aws_lb" "mainsite-alb-prod-ue1-geo" {
  provider                   = aws
  desync_mitigation_mode     = "defensive"
  drop_invalid_header_fields = "false"
  enable_deletion_protection = "false"
  enable_http2               = "true"
  enable_waf_fail_open       = "false"
  idle_timeout               = "60"
  internal                   = "false"
  ip_address_type            = "ipv4"
  load_balancer_type         = "application"
  name                       = "mainsite-alb-prod-ue1-geo"
  security_groups            = ["sg-8164fcf5"]

  subnet_mapping {
    subnet_id = "subnet-0691e5d3a1bb015d1"
  }

  subnet_mapping {
    subnet_id = "subnet-2f626b02"
  }

  subnet_mapping {
    subnet_id = "subnet-6c2cd524"
  }

  subnets = ["subnet-0691e5d3a1bb015d1", "subnet-2f626b02", "subnet-6c2cd524"]

  tags = {
    CreatorAutoTag = "cscharding"
    CreatorId      = "AROAIEUN4EZ4YR6QDZPHO"
  }

  tags_all = {
    CreatorAutoTag = "cscharding"
    CreatorId      = "AROAIEUN4EZ4YR6QDZPHO"
  }
}
