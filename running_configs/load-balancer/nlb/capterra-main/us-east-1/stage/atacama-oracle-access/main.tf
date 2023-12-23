resource "aws_lb" "atacama-oracle-access" {
  provider                         = aws
  enable_cross_zone_load_balancing = "false"
  enable_deletion_protection       = "false"
  internal                         = "true"
  ip_address_type                  = "ipv4"
  load_balancer_type               = "network"
  name                             = "atacama-oracle-access"

  subnet_mapping {
    subnet_id = "subnet-6414d82c"
  }

  subnet_mapping {
    subnet_id = "subnet-69726f44"
  }

  subnets = ["subnet-6414d82c", "subnet-69726f44"]

  tags = {
    CreatorAutoTag = "cscharding"
    CreatorId      = "AROAIEUN4EZ4YR6QDZPHO"
  }

  tags_all = {
    CreatorAutoTag = "cscharding"
    CreatorId      = "AROAIEUN4EZ4YR6QDZPHO"
  }
}
