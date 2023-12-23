terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.40.0"
    }
    external = {
      source  = "hashicorp/external"
      version = ">= 2.2.3"
    }
  }
  required_version = ">= 1.1.0"
}