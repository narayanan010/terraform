resource "aws_security_group" "ld-relay-proxy-sg" {
    provider                 = aws.awscaller_account
    name                     = "ld-relay-proxy-sg"
    vpc_id                   = "vpc-0715b585d83b5dac0"
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
    cidr_blocks              = ["10.114.54.89/32", "10.114.55.48/32", "10.114.54.60/32", "10.114.55.70/32"]
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
    source_security_group_id = "sg-03dc2808b9ca5f3a2"
    ipv6_cidr_blocks         = null
    description              = "Allow ingress from Lambda Security Group"
    security_group_id        = aws_security_group.ld-relay-proxy-sg.id
}

resource "aws_security_group_rule" "ld-rp-ingress-3" {
    provider                 = aws.awscaller_account
    type                     = "ingress"
    to_port                  = "8030"
    protocol                 = "tcp"
    from_port                = "8030"
    cidr_blocks              = ["10.114.32.0/24", "10.114.33.0/24", "10.114.34.0/24", "10.114.35.0/24"]
    ipv6_cidr_blocks         = null
    description              = "Allow ingress from us-east-1 EKS Stage CIDR Range 1"
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

data "aws_key_pair" "search_stage_key" {
  provider                   = aws.awscaller_account
  key_name                   = "capterra-search-staging-key-ue1"
}

data "aws_kms_key" "search_stage_ebs_kms_key" {
  provider                   = aws.awscaller_account
  key_id                     = "2d88cc00-f8f3-4829-a0e6-82cfb39c13d2"
}

resource "aws_instance" "ld_relay_proxy_stage" {
  provider                   = aws.awscaller_account
  ami                        = "ami-02eac2c0129f6376b"
  instance_type              = "t3.medium"
  availability_zone          = "us-east-1a"
  key_name                   = data.aws_key_pair.search_stage_key.key_name
  vpc_security_group_ids     = [aws_security_group.ld-relay-proxy-sg.id]
  subnet_id                  = "subnet-0272efa24d4855bfb"
  iam_instance_profile       = "GartnerEC2SSMRole"
  monitoring                 = true
  root_block_device {
    delete_on_termination    = true
    encrypted                = true
    volume_size              = "70"
    volume_type              = "gp3"
    kms_key_id               = data.aws_kms_key.search_stage_ebs_kms_key.arn
  }
  tags                       = {
    Name                     = "ld-relay-proxy-stage"
  } 
}