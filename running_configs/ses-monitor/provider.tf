terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
  }
  required_version = ">= 1.2"
}

provider "aws" {
  region = var.modulecaller_source_region
  assume_role {
    role_arn = var.modulecaller_assume_role_primary_account
  }
  default_tags {
    tags = module.tags_resource_module.tags
  }
}

module "tags_resource_module" {
  source = "git::ssh://git@github.com/capterra/terraform.git//modules/tagging-resource-module"

  application       = "elasticsearch"
  app_component     = "network"
  function          = "vpc_endpoint"
  business_unit     = "gdm"
  app_contacts      = "capterra_devops"
  created_by        = "james.nurmi@gartner.com"
  system_risk_class = "3"
  region            = var.modulecaller_source_region
  monitoring        = "false"
  terraform_managed = "true"
  environment       = "prod"
  app_environment   = "prod"

  tags = {
    "repository" = "https://github.com/capterra/terraform.git"
  }
}

