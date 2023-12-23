terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.62.0"        # Static version, due existing bug: https://github.com/hashicorp/terraform-provider-aws/issues/31764
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.2.2"
    }
    external = {
      source  = "hashicorp/external"
      version = ">= 2.2.2"
    }
    template = {
      source  = "hashicorp/template"
      version = ">= 2.2.0"
    }
  }
  required_version = ">= 1.3.7"
}

data "terraform_remote_state" "common_resources" {
  backend = "s3"
  config = {
    bucket         = "capterra-terraform-state"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "capterra-terraform-lock-table"
    key            = "ecs/search-${terraform.workspace}/terraform.tfstate"
  }
}