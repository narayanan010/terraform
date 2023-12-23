resource "aws_ec2_managed_prefix_list" "capterra_production_vpc_private" {
  name           = "private subnets from the capterra account's production vpc"
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


resource "aws_ec2_managed_prefix_list" "msk_ec2" {
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
}


resource "aws_security_group" "click_streaming_lambda" {
  name        = "ClickStreamingLambda"
  description = "Allows lambdas to connect to Click Streaming Memory DB and MSK"
  vpc_id      = "vpc-0e9d1ca8ead4977da"
}

resource "aws_security_group_rule" "click_streaming_lambda_sgr_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.click_streaming_lambda.id
}


locals {
  msk_ingress = [
    {
      from_port   = "9092",
      to_port     = "9092",
      description = "capterra/production/private: plaintext"
    },
    {
      from_port   = "9094",
      to_port     = "9094",
      description = "capterra/production/private: TLS from within AWS"
    },
    {
      from_port   = "9096",
      to_port     = "9096",
      description = "capterra/production/private: SASL/SCRAM from within AWS"
    },
    {
      from_port   = "9098",
      to_port     = "9098",
      description = "capterra/production/private: IAM access control from within AWS"
    },
    {
      from_port   = "2181",
      to_port     = "2182",
      description = "capterra/production/private: Apache ZooKeeper nodes default and TLS"
    }
  ]
  lambda_ingress = [
    {
      from_port   = "9092",
      to_port     = "9092",
      description = "Lambda SG: plaintext"
    },
    {
      from_port   = "9094",
      to_port     = "9094",
      description = "Lambda SG: TLS from within AWS"
    },
    {
      from_port   = "9096",
      to_port     = "9096",
      description = "Lambda SG: SASL/SCRAM from within AWS"
    },
    {
      from_port   = "9098",
      to_port     = "9098",
      description = "Lambda SG: IAM access control from within AWS"
    },
    {
      from_port   = "2181",
      to_port     = "2182",
      description = "Lambda SG: Apache ZooKeeper nodes default and TLS"
    },
  ]
}


resource "aws_security_group" "click_streaming_msk" {
  name        = "click_streaming_msk"
  description = "Click Streaming MSK"
  vpc_id      = "vpc-0e9d1ca8ead4977da"
}

resource "aws_security_group_rule" "click_streaming_msk_sgr_ingress" {
  for_each          = { for rules in local.msk_ingress : rules.from_port => rules }
  type              = "ingress"
  protocol          = "tcp"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  description       = each.value.description
  prefix_list_ids   = [aws_ec2_managed_prefix_list.capterra_production_vpc_private.id]
  security_group_id = aws_security_group.click_streaming_msk.id
  cidr_blocks       = []
  ipv6_cidr_blocks  = []
}

resource "aws_security_group_rule" "click_streaming_msk_sgr_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.click_streaming_msk.id
}

resource "aws_security_group_rule" "click_streaming_lambda_sgr_ingress" {
  for_each                 = { for rules in local.lambda_ingress : rules.from_port => rules }
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  description              = each.value.description
  source_security_group_id = aws_security_group.click_streaming_lambda.id
  security_group_id        = aws_security_group.click_streaming_msk.id
}

resource "aws_security_group_rule" "click_streaming_internal_sgr01_ingress" {
  type              = "ingress"
  description       = ""
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["10.114.0.0/16"]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  security_group_id = aws_security_group.click_streaming_msk.id
}

resource "aws_security_group_rule" "click_streaming_internal_sgr02_ingress" {
  type              = "ingress"
  description       = "Equinix & also all 10.114 - 2022-05-05"
  from_port         = 8
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["10.114.0.0/16"]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  security_group_id = aws_security_group.click_streaming_msk.id
}

resource "aws_security_group_rule" "click_streaming_internal_sgr03_ingress" {
  type              = "ingress"
  description       = "Internal"
  from_port         = 9096
  to_port           = 9096
  protocol          = "tcp"
  cidr_blocks       = ["10.114.0.0/16"]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  security_group_id = aws_security_group.click_streaming_msk.id
}

resource "aws_security_group_rule" "click_streaming_internal_sgr03_ingress_9094" {
  type              = "ingress"
  description       = "Internal"
  from_port         = 9094
  to_port           = 9094
  protocol          = "tcp"
  cidr_blocks       = ["10.114.0.0/16"]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  security_group_id = aws_security_group.click_streaming_msk.id
}



locals {
  msk_ec2_ingress = [
    {
      from_port   = "9092",
      to_port     = "9092",
      description = "EC2 Instances (jenkins/ebdas/cd1a): plaintext"
    },
    {
      from_port   = "9094",
      to_port     = "9094",
      description = "EC2 Instances (jenkins/ebdas/cd1a): TLS from within AWS"
    },
    {
      from_port   = "9096",
      to_port     = "9096",
      description = "EC2 Instances (jenkins/ebdas/cd1a): SASL/SCRAM from within AWS"
    },
    {
      from_port   = "9098",
      to_port     = "9098",
      description = "EC2 Instances (jenkins/ebdas/cd1a): IAM access control from within AWS"
    },
    {
      from_port   = "2181",
      to_port     = "2182",
      description = "EC2 Instances (jenkins/ebdas/cd1a): Apache ZooKeeper nodes default and TLS"
    },
  ]
}


resource "aws_security_group" "click_streaming_msk_ec2" {
  name        = "click_streaming_msk_ec2"
  description = "Click Streaming MSK (Jenkins, edbas, cd1a)"
  vpc_id      = "vpc-0e9d1ca8ead4977da"
}

resource "aws_security_group_rule" "click_streaming_msk_ec2_sgr01_ingress" {
  for_each          = { for rules in local.msk_ec2_ingress : rules.from_port => rules }
  type              = "ingress"
  protocol          = "tcp"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  description       = each.value.description
  prefix_list_ids   = [aws_ec2_managed_prefix_list.msk_ec2.id]
  security_group_id = aws_security_group.click_streaming_msk_ec2.id
}

resource "aws_security_group_rule" "click_streaming_msk_ec2_sgr02_ingress" {
  type                     = "ingress"
  description              = "MSK JMX Exporter for Datadog Monitoring"
  from_port                = 11001
  to_port                  = 11002
  protocol                 = "tcp"
  source_security_group_id = "sg-059ec2e895efd59e2"
  prefix_list_ids          = []
  security_group_id        = aws_security_group.click_streaming_msk_ec2.id
}

resource "aws_security_group_rule" "click_streaming_msk_ec2_sgr_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.click_streaming_msk_ec2.id
}

