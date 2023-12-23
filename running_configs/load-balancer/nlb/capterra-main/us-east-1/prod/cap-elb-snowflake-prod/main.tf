resource "aws_lb" "cap-elb-snowflake-prod" {
  provider                         = aws
  enable_cross_zone_load_balancing = "true"
  enable_deletion_protection       = "false"
  internal                         = "true"
  ip_address_type                  = "ipv4"
  load_balancer_type               = "network"
  name                             = "cap-elb-snowflake-prod"

  subnet_mapping {
    subnet_id = "subnet-0691e5d3a1bb015d1"
  }

  subnet_mapping {
    subnet_id = "subnet-1529d05d"
  }

  subnet_mapping {
    subnet_id = "subnet-87666faa"
  }

  subnets = ["subnet-0691e5d3a1bb015d1", "subnet-1529d05d", "subnet-87666faa"]

  tags = {
    APPLICATION = "SNOWFLAKE"
    ENVIRONMENT = "PRODUCTION"
  }

  tags_all = {
    APPLICATION = "SNOWFLAKE"
    ENVIRONMENT = "PRODUCTION"
  }
}
