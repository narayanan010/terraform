resource "aws_security_group" "ld-relay-proxy-sg" {
    provider                 = aws.awscaller_account
    name                     = "ld-relay-proxy-sg"
    vpc_id                   = "vpc-02f17c4cb074d6783"
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
    cidr_blocks              = ["10.114.60.103/32"]
    ipv6_cidr_blocks         = null
    description              = "Allow ingress from us-west-2 Bastion server"
    security_group_id        = aws_security_group.ld-relay-proxy-sg.id
    depends_on               = [
      aws_security_group.ld-relay-proxy-sg
    ]
}

resource "aws_security_group_rule" "ld-rp-ingress-2" {
    provider                 = aws.awscaller_account
    type                     = "ingress"
    to_port                  = "8030"
    protocol                 = "tcp"
    from_port                = "8030"
    source_security_group_id = "sg-0dd4f152464bb87bc"
    ipv6_cidr_blocks         = null
    description              = "Allow ingress from Lambda Security Group"
    security_group_id        = aws_security_group.ld-relay-proxy-sg.id
    depends_on               = [
      aws_security_group.ld-relay-proxy-sg
    ]
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
    depends_on               = [
      aws_security_group.ld-relay-proxy-sg
    ]
}

data "aws_key_pair" "search_prod_dr_key" {
  provider                   = aws.awscaller_account
  key_name                   = "capterra-search-prod-dr-us-west-2"
}

data "aws_kms_key" "seach_prod_dr_ebs_kms_key" {
  provider                   = aws.awscaller_account
  key_id                     = "47627af3-1024-4472-98c4-996021ad86a8"
}

resource "aws_instance" "ld_relay_proxy_prod" {
  provider                   = aws.awscaller_account
  ami                        = "ami-069398a1d07a2599d"
  instance_type              = "m5.2xlarge"
  availability_zone          = "us-west-2a"
  key_name                   = data.aws_key_pair.search_prod_dr_key.key_name
  vpc_security_group_ids     = [aws_security_group.ld-relay-proxy-sg.id]
  subnet_id                  = "subnet-0b575f7aa82e4d0f2"
  iam_instance_profile       = "GartnerEC2SSMRole"
  monitoring                 = true
  root_block_device {
    delete_on_termination    = true
    encrypted                = true
    volume_size              = "100"
    volume_type              = "gp3"
    kms_key_id               = data.aws_kms_key.seach_prod_dr_ebs_kms_key.arn
  }
  tags                       = {
    Name                     = "ld-relay-proxy-prod-dr"
    backup-dlm               = "prod"
  } 
  depends_on                 = [
    aws_security_group.ld-relay-proxy-sg
  ]
}