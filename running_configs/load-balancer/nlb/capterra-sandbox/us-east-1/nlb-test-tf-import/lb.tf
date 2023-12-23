resource "aws_lb" "nlb-test-tf-import" {
  provider = aws
  access_logs {
    bucket  = "capterra-loadbalancer-logs"
    enabled = "true"
    prefix  = "nlb-test-tf-import"
  }

  enable_cross_zone_load_balancing = "false"
  enable_deletion_protection       = "false"
  internal                         = "true"
  ip_address_type                  = "ipv4"
  load_balancer_type               = "network"
  name                             = "nlb-test-tf-import"

  subnet_mapping {
    subnet_id = "subnet-1f0b5342"
  }

  subnet_mapping {
    subnet_id = "subnet-416a870b"
  }

  subnet_mapping {
    subnet_id = "subnet-70616114"
  }

  subnets = ["subnet-1f0b5342", "subnet-416a870b", "subnet-70616114"]

  tags = {
    CreatorAutoTag = "nnarasimhan"
    CreatorId      = "AROA5X7SKMZOTLE2HOAXN"
    Name           = "nlb-test-tf-import"
  }

  tags_all = {
    CreatorAutoTag = "nnarasimhan"
    CreatorId      = "AROA5X7SKMZOTLE2HOAXN"
    Name           = "nlb-test-tf-import"
  }
}
