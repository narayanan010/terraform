resource "aws_route_table" "rtb-06a7fd6c63baa7f20" {
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "nat-0de78123667fe9264"
  }

  route {
    cidr_block                = "10.114.120.0/22"
    vpc_peering_connection_id = "pcx-0be6b46371b605fc9"
  }

  route {
    cidr_block                = "10.114.48.0/21"
    vpc_peering_connection_id = "pcx-094e5b30ad34ea484"
  }

  route {
    cidr_block                = "10.114.56.0/21"
    vpc_peering_connection_id = "pcx-0fc21aa97de83709d"
  }

  tags = {
    Name = "CapterraSearchProd-DR-private"
  }

  tags_all = {
    Name = "CapterraSearchProd-DR-private"
  }

  vpc_id = "vpc-02f17c4cb074d6783"
}

resource "aws_route_table" "rtb-0a3a44adfcd1c3cd4" {
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "igw-0d0cff241d2149f73"
  }

  route {
    cidr_block                = "10.114.48.0/21"
    vpc_peering_connection_id = "pcx-094e5b30ad34ea484"
  }

  route {
    cidr_block                = "10.114.56.0/21"
    vpc_peering_connection_id = "pcx-0fc21aa97de83709d"
  }

  tags = {
    Name = "CapterraSearchProd-DR-rtb-public"
  }

  tags_all = {
    Name = "CapterraSearchProd-DR-rtb-public"
  }

  vpc_id = "vpc-02f17c4cb074d6783"
}
