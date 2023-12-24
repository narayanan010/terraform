resource "aws_security_group" "allow_tls" {
  name               = "allow_tls"
  description        = "Security group to allow tls connections on inbound"
  vpc_id             = "vpc-0035ac7a"
  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
    ipv6_cidr_blocks = ["2600:1f18:662a:e700::/56"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}