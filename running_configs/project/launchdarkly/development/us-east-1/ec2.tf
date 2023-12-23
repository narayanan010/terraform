resource "aws_security_group" "ld-relay-proxy-sg" {
    provider                 = aws.awscaller_account
    name                     = "ld-relay-proxy-sg"
    vpc_id                   = "vpc-0b340ad818cf0648b"
    description              = "Security group associated with EC2 created for Launchdarkly Relay Proxy server"
    lifecycle {
    create_before_destroy    = true
    }
}

resource "aws_security_group_rule" "ld-rp-ingress-1" {
    provider                 = aws.awscaller_account
    type                     = "ingress"
    to_port                  = "22"
    protocol                 = "tcp"
    from_port                = "22"
    cidr_blocks              = ["10.114.54.89/32"]
    ipv6_cidr_blocks         = null
    description              = "Allow ingress from us-east-1 Bastion server"
    security_group_id        = aws_security_group.ld-relay-proxy-sg.id
}

resource "aws_security_group_rule" "ld-rp-ingress-2" {
    provider                 = aws.awscaller_account
    type                     = "ingress"
    to_port                  = "8030"
    protocol                 = "tcp"
    from_port                = "8030"
    source_security_group_id = "sg-09b7d717538e43dd7"
    ipv6_cidr_blocks         = null
    description              = "Allow ingress from Lambda Security Group"
    security_group_id        = aws_security_group.ld-relay-proxy-sg.id
}

resource "aws_security_group_rule" "ld-rp-ingress-3" {
    provider                 = aws.awscaller_account
    type                     = "ingress"
    to_port                  = "22"
    protocol                 = "tcp"
    from_port                = "22"
    cidr_blocks              = ["10.114.54.60/32"]
    ipv6_cidr_blocks         = null
    description              = "Allow ingress from us-east-1 (edbas2023-1a) bastion server"
    security_group_id        = aws_security_group.ld-relay-proxy-sg.id
}

resource "aws_security_group_rule" "ld-rp-ingress-4" {
    provider                 = aws.awscaller_account
    type                     = "ingress"
    to_port                  = "22"
    protocol                 = "tcp"
    from_port                = "22"
    cidr_blocks              = ["10.114.55.70/32"]
    ipv6_cidr_blocks         = null
    description              = "Allow ingress from us-east-1 (edbas2023-1b) bastion server"
    security_group_id        = aws_security_group.ld-relay-proxy-sg.id
}

resource "aws_security_group_rule" "ld-rp-ingress-5" {
    provider                 = aws.awscaller_account
    type                     = "ingress"
    to_port                  = "22"
    protocol                 = "tcp"
    from_port                = "22"
    cidr_blocks              = ["10.114.55.48/32"]
    ipv6_cidr_blocks         = null
    description              = "Allow ingress from us-east-1b (edbas3) bastion server"
    security_group_id        = aws_security_group.ld-relay-proxy-sg.id
}

resource "aws_security_group_rule" "ld-relay-proxy-egress" {
    provider                 = aws.awscaller_account
    type                     = "egress"
    to_port                  = "0"
    protocol                 = "-1"
    from_port                = "0"
    cidr_blocks              = ["0.0.0.0/0"]
    ipv6_cidr_blocks         = null
    description              = "Allow egress to everywhere"
    security_group_id        = aws_security_group.ld-relay-proxy-sg.id
}

data "aws_key_pair" "search_dev_key" {
  provider                   = aws.awscaller_account
  key_name                   = "search-dev-ec2-key-pair"
}

data "aws_kms_key" "search_dev_ebs_kms_key" {
  provider                   = aws.awscaller_account
  key_id                     = "f481ef63-3fcf-4f62-9842-25aceb01267b"
}

resource "aws_instance" "ld_relay_proxy_dev" {
  provider                   = aws.awscaller_account
  ami                        = "ami-02e136e904f3da870"
  instance_type              = "t3.small"
  availability_zone          = "us-east-1a"
  key_name                   = data.aws_key_pair.search_dev_key.key_name
  vpc_security_group_ids     = [aws_security_group.ld-relay-proxy-sg.id]
  subnet_id                  = "subnet-08c97978fc2a3bb22"
  iam_instance_profile       = "GartnerEC2SSMRole"
  monitoring                 = true
  root_block_device {
    delete_on_termination    = true
    encrypted                = true
    volume_size              = "40"
    volume_type              = "gp3"
    kms_key_id               = data.aws_kms_key.search_dev_ebs_kms_key.arn
  }
  tags                       = {
    Name                     = "ld-relay-proxy-dev"
  } 
}