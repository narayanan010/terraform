resource "aws_ec2_managed_prefix_list" "capterra_prod_vpc_private" {
  name           = "private subnets from the capterra account's prod vpc"
  address_family = "IPv4"
  max_entries    = 3

  entry {
    cidr        = "10.114.24.0/24"
    description = "priv-subnet-1-us-east-1a"
  }

  entry {
    cidr        = "10.114.25.0/24"
    description = "priv-subnet-2-us-east-1b"
  }

  entry {
    cidr        = "10.114.29.0/24"
    description = "priv-subnet-3-us-east-1c"
  }

  tags = {
  }
}


resource "aws_ec2_managed_prefix_list" "capterra_ec2" {
  name           = "Jenkins prod (with nodes), edbas, cd1a from capterra account"
  address_family = "IPv4"
  max_entries    = 12

  entry {
    cidr        = "10.114.54.209/32"
    description = "Jenkins-Production 5/31/19"
  }

  entry {
    cidr        = "10.114.24.123/32"
    description = "jenkins-prod-wn1-e1a"
  }

  entry {
    cidr        = "10.114.24.144/32"
    description = "jenkins-prod-wn2-e1a"
  }

  entry {
    cidr        = "10.114.24.228/32"
    description = "jenkins-prod-wn3-e1a"
  }

  entry {
    cidr        = "10.114.24.145/32"
    description = "jenkins-prod-wn4-e1a"
  }

  entry {
    cidr        = "10.114.24.21/32"
    description = "jenkins-prod-wn5-e1a"
  }

  entry {
    cidr        = "10.114.24.203/32"
    description = "jenkins-prod-wn6-e1a"
  }

  entry {
    cidr        = "10.114.54.89/32"
    description = "edbas Virginia"
  }

  entry {
    cidr        = "10.114.97.23/32"
    description = "edbas Paris"
  }

  entry {
    cidr        = "10.114.89.214/32"
    description = "edbas India"
  }

  entry {
    cidr        = "10.114.24.128/32"
    description = "cd1a"
  }

  tags = {
  }
}


resource "aws_security_group" "declared_data_msk" {
  name        = "declared_data_msk"
  description = "Declared Data MSK"
  vpc_id      = "vpc-0e9d1ca8ead4977da"

  ingress {
    description     = "capterra/prod/private: plaintext"
    from_port       = 9092
    to_port         = 9092
    protocol        = "tcp"
    prefix_list_ids = [aws_ec2_managed_prefix_list.capterra_prod_vpc_private.id]
  }

  ingress {
    description     = "capterra/prod/private: TLS from within AWS"
    from_port       = 9094
    to_port         = 9094
    protocol        = "tcp"
    prefix_list_ids = [aws_ec2_managed_prefix_list.capterra_prod_vpc_private.id]
  }

  ingress {
    description     = "capterra/prod/private: SASL/SCRAM from within AWS"
    from_port       = 9096
    to_port         = 9096
    protocol        = "tcp"
    prefix_list_ids = [aws_ec2_managed_prefix_list.capterra_prod_vpc_private.id]
  }

  ingress {
    description     = "capterra/prod/private: IAM access control from within AWS"
    from_port       = 9098
    to_port         = 9098
    protocol        = "tcp"
    prefix_list_ids = [aws_ec2_managed_prefix_list.capterra_prod_vpc_private.id]
  }

  ingress {
    description     = "capterra/prod/private: Apache ZooKeeper nodes default and TLS"
    from_port       = 2181
    to_port         = 2182
    protocol        = "tcp"
    prefix_list_ids = [aws_ec2_managed_prefix_list.capterra_prod_vpc_private.id]
  }

  #  Public template section
  #
  #  ingress {
  #    description = "TLS - public access"
  #    from_port   = 9194
  #    to_port     = 9194
  #    protocol    = "tcp"
  #  }
  #
  #  ingress {
  #    description = "SASL/SCRAM - public access"
  #    from_port   = 9196
  #    to_port     = 9196
  #    protocol    = "tcp"
  #  }
  #
  #  ingress {
  #    description = "IAM access control - public access"
  #    from_port   = 9198
  #    to_port     = 9198
  #    protocol    = "tcp"
  #  }

  #  From AWS template section
  #
  #  ingress {
  #    description = "TLS from within AWS"
  #    from_port   = 9094
  #    to_port     = 9094
  #    protocol    = "tcp"
  #  }
  #
  #  ingress {
  #    description = "SASL/SCRAM from within AWS"
  #    from_port   = 9096
  #    to_port     = 9096
  #    protocol    = "tcp"
  #  }
  #
  #  ingress {
  #    description = "IAM access control from within AWS"
  #    from_port   = 9098
  #    to_port     = 9098
  #    protocol    = "tcp"
  #  }

  # ZooKeeper template section
  #
  #  ingress {
  #    description = "Apache ZooKeeper nodes default and TLS"
  #    from_port   = 2181
  #    to_port     = 2182
  #    protocol    = "tcp"
  #  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "declared_data_msk_capterra_ec2" {
  name        = "declared_data_msk_capterra_ec2"
  description = "Declared Data MSK (Jenkins, edbas, cd1a)"
  vpc_id      = "vpc-0e9d1ca8ead4977da"

  ingress {
    description     = "EC2 Instances (jenkins/ebdas/cd1a): plaintext"
    from_port       = 9092
    to_port         = 9092
    protocol        = "tcp"
    prefix_list_ids = [aws_ec2_managed_prefix_list.capterra_ec2.id]
  }

  ingress {
    description     = "EC2 Instances (jenkins/ebdas/cd1a): TLS from within AWS"
    from_port       = 9094
    to_port         = 9094
    protocol        = "tcp"
    prefix_list_ids = [aws_ec2_managed_prefix_list.capterra_ec2.id]
  }

  ingress {
    description     = "EC2 Instances (jenkins/ebdas/cd1a): SASL/SCRAM from within AWS"
    from_port       = 9096
    to_port         = 9096
    protocol        = "tcp"
    prefix_list_ids = [aws_ec2_managed_prefix_list.capterra_ec2.id]
  }

  ingress {
    description     = "EC2 Instances (jenkins/ebdas/cd1a): IAM access control from within AWS"
    from_port       = 9098
    to_port         = 9098
    protocol        = "tcp"
    prefix_list_ids = [aws_ec2_managed_prefix_list.capterra_ec2.id]
  }

  ingress {
    description     = "EC2 Instances (jenkins/ebdas/cd1a): Apache ZooKeeper nodes default and TLS"
    from_port       = 2181
    to_port         = 2182
    protocol        = "tcp"
    prefix_list_ids = [aws_ec2_managed_prefix_list.capterra_ec2.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
