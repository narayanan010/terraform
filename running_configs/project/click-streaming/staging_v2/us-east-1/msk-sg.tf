resource "aws_ec2_managed_prefix_list" "capterra_staging_vpc_private" {
  name           = "private subnets from the capterra account's staging vpc"
  address_family = "IPv4"
  max_entries    = 5

  entry {
    cidr        = "10.114.32.0/24"
    description = "priv-subnet-1-us-east-1a"
  }

  entry {
    cidr        = "10.114.33.0/24"
    description = "priv-subnet-2-us-east-1b"
  }

  entry {
    cidr        = "10.114.34.0/24"
    description = "priv-subnet-3-us-east-1c"
  }

  entry {
    cidr        = "10.114.35.0/24"
    description = "priv-subnet-4-us-east-1d"
  }

  entry {
    cidr        = "10.114.36.0/24"
    description = "priv-subnet-5-us-east-1f"
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

  # tags = {
  # }
}


resource "aws_security_group" "click_streaming_lambda" {
  name        = "ClickStreamingLambda"
  description = "Allows lambdas to connect to Click Streaming Memory DB and MSK"
  vpc_id      = "vpc-0715b585d83b5dac0"
}


locals {
  msk_ingress = [
    {
      from_port   = "9092",
      to_port     = "9092",
      description = "capterra/staging/private: plaintext"
    },
    {
      from_port   = "9094",
      to_port     = "9094",
      description = "capterra/staging/private: TLS from within AWS"
    },
    {
      from_port   = "9096",
      to_port     = "9096",
      description = "capterra/staging/private: SASL/SCRAM from within AWS"
    },
    {
      from_port   = "9098",
      to_port     = "9098",
      description = "capterra/staging/private: IAM access control from within AWS"
    },
    {
      from_port   = "2181",
      to_port     = "2182",
      description = "capterra/staging/private: Apache ZooKeeper nodes default and TLS"
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
    }
  ]
}


resource "aws_security_group" "click_streaming_msk" {
  name        = "click_streaming_msk"
  description = "Click Streaming MSK"
  vpc_id      = "vpc-0715b585d83b5dac0"
}

resource "aws_security_group_rule" "click_streaming_msk_sgr_ingress" {
  for_each          = { for rules in local.msk_ingress : rules.from_port => rules }
  type              = "ingress"
  protocol          = "tcp"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  description       = each.value.description
  prefix_list_ids   = [aws_ec2_managed_prefix_list.capterra_staging_vpc_private.id]
  security_group_id = aws_security_group.click_streaming_msk.id
  cidr_blocks       = []
  ipv6_cidr_blocks  = []
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

resource "aws_security_group_rule" "click_streaming_internal_ingress_sgr01" {
  type              = "ingress"
  description       = "Internal-Traffic"
  from_port         = 9096
  to_port           = 9096
  protocol          = "tcp"
  cidr_blocks       = ["10.114.0.0/16"]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  security_group_id = aws_security_group.click_streaming_msk.id
}

resource "aws_security_group_rule" "click_streaming_internal_ingress_sgr01_9094" {
  type              = "ingress"
  description       = "Internal-Traffic"
  from_port         = 9094
  to_port           = 9094
  protocol          = "tcp"
  cidr_blocks       = ["10.114.0.0/16"]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  security_group_id = aws_security_group.click_streaming_msk.id
}



resource "aws_security_group_rule" "click_streaming_internal_ingress_sgr02" {
  type              = "ingress"
  description       = "Internal-Ping"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp"
  cidr_blocks       = ["10.114.0.0/16"]
  ipv6_cidr_blocks  = []
  prefix_list_ids   = []
  security_group_id = aws_security_group.click_streaming_msk.id
}

resource "aws_security_group_rule" "click_streaming_internal_ingress_sgr03" {
  type        = "ingress"
  description = "MSK JMX Exporter for Datadog Monitoring"
  from_port   = 11001
  to_port     = 11002
  protocol    = "tcp"
  #cidr_blocks              = [for name in local.ec2_suffix : "${module.datadog-instance[name].private_ip}/32"]
  source_security_group_id = "sg-06a8b5b3107c86187"
  prefix_list_ids          = []
  security_group_id        = aws_security_group.click_streaming_msk.id
}

resource "aws_security_group_rule" "click_streaming_internal_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
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
      description = "EC2 Instances (jenkins/ebdas/cd1a): plaintext"
    },
    {
      from_port   = "9096",
      to_port     = "9096",
      description = "EC2 Instances (jenkins/ebdas/cd1a): plaintext"
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
    }
  ]
}

resource "aws_security_group" "click_streaming_msk_ec2" {
  name        = "click_streaming_msk_ec2"
  description = "Click Streaming MSK (Jenkins, edbas, cd1a)"
  vpc_id      = "vpc-0715b585d83b5dac0"
}
resource "aws_security_group_rule" "click_streaming_msk_ec2_sgr_ingress" {
  for_each          = { for rules in local.msk_ec2_ingress : rules.from_port => rules }
  type              = "ingress"
  protocol          = "tcp"
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  description       = each.value.description
  prefix_list_ids   = [aws_ec2_managed_prefix_list.msk_ec2.id]
  security_group_id = aws_security_group.click_streaming_msk_ec2.id
}


resource "aws_security_group_rule" "click_streaming_msk_ec2_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.click_streaming_msk_ec2.id
}

resource "aws_security_group_rule" "click_streaming_lambda_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.click_streaming_lambda.id
}
