resource "aws_vpc" "vpc-02f17c4cb074d6783" {
  assign_generated_ipv6_cidr_block     = "false"
  cidr_block                           = "10.114.144.0/21"
  enable_dns_hostnames                 = "false"
  enable_dns_support                   = "true"
  enable_network_address_usage_metrics = "false"
  instance_tenancy                     = "default"

  tags = {
    Name = "CapterraSearchProd-DR"
  }

  tags_all = {
    Name = "CapterraSearchProd-DR"
  }
}
