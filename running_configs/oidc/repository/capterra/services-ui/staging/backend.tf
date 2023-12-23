terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.10.0"
    }
  }
  required_version = ">= 1.2.5"
}

data "terraform_remote_state" "common_resources" {
  backend = "s3"
  config = {
    bucket         = "capterra-terraform-state"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "capterra-terraform-lock-table"
    key            = "oidc/common/capterra-aws-main/terraform.tfstate"
  }
}
