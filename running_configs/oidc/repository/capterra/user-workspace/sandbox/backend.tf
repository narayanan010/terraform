terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.55.0"
    }
  }
  required_version = ">= 1.2.9"
}

data "terraform_remote_state" "common_resources" {
  backend = "s3"
  config = {
    bucket         = "capterra-terraform-state"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "capterra-terraform-lock-table"
    key            = "oidc/common/capterra-sandbox/terraform.tfstate"
  }
}

