resource "aws_lb" "mainsite-alb-staging-ue1" {
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
  name                       = "mainsite-alb-staging-ue1"
  security_groups            = ["sg-0decd55befab3c6ec"]

  subnet_mapping {
    subnet_id = "subnet-6514d82d"
  }

  subnet_mapping {
    subnet_id = "subnet-f2736edf"
  }

  subnets = ["subnet-6514d82d", "subnet-f2736edf"]

  tags = {
    Name = "mainsite-alb-staging-ue1"
  }

  tags_all = {
    Name = "mainsite-alb-staging-ue1"
  }
}