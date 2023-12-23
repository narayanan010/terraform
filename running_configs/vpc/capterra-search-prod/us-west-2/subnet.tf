resource "aws_subnet" "subnet-06b11e1f55980a35c" {
  assign_ipv6_address_on_creation                = "false"
  cidr_block                                     = "10.114.147.0/24"
  enable_dns64                                   = "false"
  enable_resource_name_dns_a_record_on_launch    = "false"
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  ipv6_native                                    = "false"
  map_public_ip_on_launch                        = "false"
  private_dns_hostname_type_on_launch            = "ip-name"

  tags = {
    Name = "CapterraSearchProd-DR-us-west-2-lambda"
  }

  tags_all = {
    Name = "CapterraSearchProd-DR-us-west-2-lambda"
  }

  vpc_id = "vpc-02f17c4cb074d6783"
}

resource "aws_subnet" "subnet-08b05163ffb5a2c31" {
  assign_ipv6_address_on_creation                = "false"
  cidr_block                                     = "10.114.144.0/24"
  enable_dns64                                   = "false"
  enable_resource_name_dns_a_record_on_launch    = "false"
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  ipv6_native                                    = "false"
  map_public_ip_on_launch                        = "false"
  private_dns_hostname_type_on_launch            = "ip-name"

  tags = {
    Name = "CapterraSearchProd-DR-us-west-2-public"
  }

  tags_all = {
    Name = "CapterraSearchProd-DR-us-west-2-public"
  }

  vpc_id = "vpc-02f17c4cb074d6783"
}

resource "aws_subnet" "subnet-08eb96f92f58c5aa5" {
  assign_ipv6_address_on_creation                = "false"
  cidr_block                                     = "10.114.148.0/24"
  enable_dns64                                   = "false"
  enable_resource_name_dns_a_record_on_launch    = "false"
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  ipv6_native                                    = "false"
  map_public_ip_on_launch                        = "false"
  private_dns_hostname_type_on_launch            = "ip-name"

  tags = {
    Name = "CapterraSearchProd-DR-us-west-2c-private"
  }

  tags_all = {
    Name = "CapterraSearchProd-DR-us-west-2c-private"
  }

  vpc_id = "vpc-02f17c4cb074d6783"
}

resource "aws_subnet" "subnet-095309c0629cd20bf" {
  assign_ipv6_address_on_creation                = "false"
  cidr_block                                     = "10.114.146.0/24"
  enable_dns64                                   = "false"
  enable_resource_name_dns_a_record_on_launch    = "false"
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  ipv6_native                                    = "false"
  map_public_ip_on_launch                        = "false"
  private_dns_hostname_type_on_launch            = "ip-name"

  tags = {
    Name = "CapterraSearchProd-DR-us-west-2-private"
  }

  tags_all = {
    Name = "CapterraSearchProd-DR-us-west-2-private"
  }

  vpc_id = "vpc-02f17c4cb074d6783"
}

resource "aws_subnet" "subnet-0b575f7aa82e4d0f2" {
  assign_ipv6_address_on_creation                = "false"
  cidr_block                                     = "10.114.145.0/24"
  enable_dns64                                   = "false"
  enable_resource_name_dns_a_record_on_launch    = "false"
  enable_resource_name_dns_aaaa_record_on_launch = "false"
  ipv6_native                                    = "false"
  map_public_ip_on_launch                        = "false"
  private_dns_hostname_type_on_launch            = "ip-name"

  tags = {
    Name = "CapterraSearchProd-DR-us-west-2a-private"
  }

  tags_all = {
    Name = "CapterraSearchProd-DR-us-west-2a-private"
  }

  vpc_id = "vpc-02f17c4cb074d6783"
}
