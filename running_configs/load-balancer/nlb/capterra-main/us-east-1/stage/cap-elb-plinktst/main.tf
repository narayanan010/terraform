resource "aws_lb" "cap-elb-plinktst" {
  provider                         = aws
  enable_cross_zone_load_balancing = "true"
  enable_deletion_protection       = "false"
  internal                         = "true"
  ip_address_type                  = "ipv4"
  load_balancer_type               = "network"
  name                             = "cap-elb-plinktst"

  subnet_mapping {
    subnet_id = "subnet-05de4875508632d63"
  }

  subnet_mapping {
    subnet_id = "subnet-6414d82c"
  }

  subnet_mapping {
    subnet_id = "subnet-69726f44"
  }

  subnets = ["subnet-05de4875508632d63", "subnet-6414d82c", "subnet-69726f44"]

  tags = {
    APPLICATION = "SNOWFLAKE"
    ENVIRONMENT = "STAGING"
  }

  tags_all = {
    APPLICATION = "SNOWFLAKE"
    ENVIRONMENT = "STAGING"
  }
}