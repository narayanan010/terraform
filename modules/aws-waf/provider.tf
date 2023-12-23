terraform {
  required_providers {
    datadog = {
      source  = "datadog/datadog"
      version = ">= 3.14.0"
    }
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 4.53.0"
      configuration_aliases = [aws.primary]
    }
  }
  required_version = ">= 1.1.0"
}

data "aws_secretsmanager_secret_version" "datadog" {
  provider  = aws.primary
  secret_id = "datadog-tf"
}

provider "datadog" {
  api_key = jsondecode(data.aws_secretsmanager_secret_version.datadog.secret_string)["api_key"]
  app_key = jsondecode(data.aws_secretsmanager_secret_version.datadog.secret_string)["app_key"]
}
