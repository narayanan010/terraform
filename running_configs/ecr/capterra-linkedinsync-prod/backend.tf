terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.10.0"
    }
    external = {
      source  = "hashicorp/external"
      version = ">= 2.3.1"
    }
  }
  required_version = ">= 1.5.4"
}
