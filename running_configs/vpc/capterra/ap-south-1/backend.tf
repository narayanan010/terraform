terraform {
  backend "s3" {}
  # required_providers {
  #   aws = {
  #     source = "hashicorp/aws"
  #     version = "~> 2.55.0"
  #   }
  # }
  required_version = "~> 0.12.31"
}