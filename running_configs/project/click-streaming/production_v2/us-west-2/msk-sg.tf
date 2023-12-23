resource "aws_security_group" "click_streaming_msk_dr" {
  name        = "click_streaming_msk"
  description = "click-streaming for MSK DR"
  vpc_id      = "vpc-02f17c4cb074d6783"
}

resource "aws_security_group" "click_streaming_msk_dr_ec2" {
  name        = "click_streaming_msk_ec2"
  description = "Click Streaming MSK (Jenkins, edbas, cd1a)"
  vpc_id      = "vpc-02f17c4cb074d6783"
}

resource "aws_security_group" "click_streaming_lambda" {
  name        = "ClickStreamingLambda"
  description = "Allows lambdas to connect to Click Streaming Memory DB and MSK"
  vpc_id      = "vpc-02f17c4cb074d6783"
}

resource "aws_ec2_managed_prefix_list" "capterra_production_vpc_private" {
  name           = "private subnets from the capterra account's production dr vpc"
  address_family = "IPv4"
  max_entries    = 3

  entry {
    cidr        = "10.114.146.0/24"
    description = "CapterraSearchProd-DR-us-west-2-private"
  }

  entry {
    cidr        = "10.114.148.0/24"
    description = "CapterraSearchProd-DR-us-west-2c-private"
  }

  entry {
    cidr        = "10.114.145.0/24"
    description = "CapterraSearchProd-DR-us-west-2a-private"
  }

  tags = {
  }
}