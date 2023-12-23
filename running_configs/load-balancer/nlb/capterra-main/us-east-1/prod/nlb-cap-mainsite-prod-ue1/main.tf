resource "aws_lb" "nlb-cap-mainsite-prod-ue1" {
  provider                         = aws
  enable_cross_zone_load_balancing = "false"
  enable_deletion_protection       = "false"
  internal                         = "false"
  ip_address_type                  = "ipv4"
  load_balancer_type               = "network"
  name                             = "nlb-cap-mainsite-prod-ue1"

  subnet_mapping {
    allocation_id = "eipalloc-01b50a20169b4c7df"
    subnet_id     = "subnet-6c2cd524"
  }

  subnet_mapping {
    allocation_id = "eipalloc-0367755ad617cc72c"
    subnet_id     = "subnet-2f626b02"
  }

  subnet_mapping {
    allocation_id = "eipalloc-0e297c10818e28612"
    subnet_id     = "subnet-0691e5d3a1bb015d1"
  }

  subnets = ["subnet-0691e5d3a1bb015d1", "subnet-2f626b02", "subnet-6c2cd524"]
}
