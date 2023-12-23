resource "aws_lb" "alb-test-tf-import" {
  provider                   = aws
  desync_mitigation_mode     = "defensive"
  drop_invalid_header_fields = "false"
  enable_deletion_protection = "false"
  enable_http2               = "true"
  enable_waf_fail_open       = "false"
  idle_timeout               = "60"
  internal                   = "true"
  ip_address_type            = "ipv4"
  load_balancer_type         = "application"
  name                       = "alb-test-tf-import"
  security_groups            = ["sg-c5d117b3"]

  # subnet_mapping {
  #   subnet_id = "subnet-1f0b5342"
  # }

  # subnet_mapping {
  #   subnet_id = "subnet-416a870b"
  # }

  subnets = ["subnet-1f0b5342", "subnet-416a870b"]

  tags = {
    CreatorAutoTag = "nnarasimhan"
    CreatorId      = "AROA5X7SKMZOTLE2HOAXN"
  }

  tags_all = {
    CreatorAutoTag = "nnarasimhan"
    CreatorId      = "AROA5X7SKMZOTLE2HOAXN"
  }
}
