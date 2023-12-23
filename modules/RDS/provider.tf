terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 4.67.0"
      configuration_aliases = [aws.primary, aws.secondary]
    }
  }
  required_version = ">= 1.1.5"
}

data "aws_caller_identity" "primary_current" {
  provider = aws.primary
}

data "aws_caller_identity" "secondary_current" {
  provider = aws.secondary
}

data "aws_region" "primary_current" {
  provider = aws.primary
}

data "aws_region" "secondary_current" {
  provider = aws.secondary
}
