terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.10.0"
    }
    # null = {
    #   source  = "hashicorp/null"
    #   version = ">= 3.2.0"
    # }
  }
  required_version = ">= 1.2.5"
}
