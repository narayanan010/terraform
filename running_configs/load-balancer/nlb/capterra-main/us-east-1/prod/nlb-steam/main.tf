resource "aws_lb" "NLB-steam" {
  enable_cross_zone_load_balancing = "false"
  enable_deletion_protection       = "false"
  internal                         = "false"
  ip_address_type                  = "ipv4"
  load_balancer_type               = "network"
  name                             = "NLB-steam"

  subnet_mapping {
    subnet_id = "subnet-021f383aab3bb6a76"
  }

  subnets = ["subnet-021f383aab3bb6a76"]

  tags = {
    ENVIRONMENT = "PRODUCTION"
    Name        = "NLB-steam"
  }

  tags_all = {
    ENVIRONMENT = "PRODUCTION"
    Name        = "NLB-steam"
  }
}