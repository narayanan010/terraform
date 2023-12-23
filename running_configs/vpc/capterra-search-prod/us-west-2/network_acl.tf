resource "aws_default_network_acl" "acl-048951b924e2a6bd2" {
  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "-1"
    rule_no    = "100"
    to_port    = "0"
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "-1"
    rule_no    = "100"
    to_port    = "0"
  }
  
  default_network_acl_id = "acl-048951b924e2a6bd2"
  subnet_ids             = ["subnet-06b11e1f55980a35c", "subnet-08b05163ffb5a2c31", "subnet-08eb96f92f58c5aa5", "subnet-095309c0629cd20bf", "subnet-0b575f7aa82e4d0f2"]
}
