terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.14.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.11.0"
    }
  }
  required_version = ">= 1.1.0"
}

data "terraform_remote_state" "eks_cluster_sandbox" {
  backend = "s3"
  config = {
    bucket         = "capterra-terraform-state"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "capterra-terraform-lock-table"
    key            = "eks/sandbox_example/cluster/terraform.tfstate"
  }
}
