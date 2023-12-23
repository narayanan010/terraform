data "aws_caller_identity" "current" {}

data "terraform_remote_state" "github_oidc_roles" {
  backend = "s3"
  config = {
    bucket         = "capterra-terraform-state"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "capterra-terraform-lock-table"
    key            = "oidc/capterra-aws-admin/terraform.tfstate"
  }
}

data "aws_iam_policy_document" "database_deployer_assume_role" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]

    principals {
      type        = "AWS"
      identifiers = [data.terraform_remote_state.github_oidc_roles.outputs.role_databases_github_role_arn]
    }
  }
}

resource "aws_iam_role" "database_deployer" {
  name_prefix        = "github-actions-db-deployer-${var.environment}-"
  assume_role_policy = data.aws_iam_policy_document.database_deployer_assume_role.json

  inline_policy {
    name   = "database_deployer"
    policy = data.aws_iam_policy_document.database_deployer.json
  }

  lifecycle {
    ignore_changes = [
      tags,
      tags_all
    ]
  }
}

data "aws_iam_policy_document" "database_deployer" {
  statement {
    actions = [
      "cloudwatch:DeleteAlarms",
      "cloudwatch:Describe*",
      "cloudwatch:DisableAlarmActions",
      "cloudwatch:EnableAlarmActions",
      "cloudwatch:Get*",
      "cloudwatch:List*",
      "cloudwatch:PutMetricAlarm",
      "datapipeline:ActivatePipeline",
      "datapipeline:CreatePipeline",
      "datapipeline:DeletePipeline",
      "datapipeline:DescribeObjects",
      "datapipeline:DescribePipelines",
      "datapipeline:GetPipelineDefinition",
      "datapipeline:ListPipelines",
      "datapipeline:PutPipelineDefinition",
      "datapipeline:QueryObjects",
      "docdb-elastic:*",
      "dynamodb:*",
      "ec2:Describe*",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "elasticache:*",
      "iam:ListRoles",
      "iam:GetRole",
      "kms:Describe*",
      "kms:List*",
      "lambda:ListFunctions",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:FilterLogEvents",
      "logs:GetLogEvents",
      "logs:Create*",
      "logs:PutLogEvents",
      "logs:PutMetricFilter",
      "rds:*",
      "redshift:*",
      "secretsmanager:GetRandomPassword",
      "kms:*"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:DeleteSecurityGroup"
    ]
    resources = [
      "arn:aws:ec2:*:*:security-group/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/environment"
      values   = ["${var.environment}"]
    }
  }
  statement {
    actions = [
      "ec2:DeleteTags",
      "ec2:DescribeTags",
      "ec2:CreateTags"
    ]
    resources = [
      "arn:aws:ec2:*:*:security-group/*"
    ]
  }
  statement {
    actions = [
      "iam:PassRole"
    ]
    resources = [
      "arn:aws:iam::*:role/rds-monitoring-role",
      "arn:aws:iam::*:role/rdbms-lambda-access",
      "arn:aws:iam::*:role/lambda_exec_role",
      "arn:aws:iam::*:role/lambda-dynamodb-*",
      "arn:aws:iam::*:role/lambda-vpc-execution-role",
      "arn:aws:iam::*:role/DataPipelineDefaultRole",
      "arn:aws:iam::*:role/DataPipelineDefaultResourceRole"
    ]
  }
  statement {
    actions = [
      "lambda:AddPermission",
      "lambda:CreateFunction",
      "lambda:GetFunction",
      "lambda:InvokeFunction",
      "lambda:UpdateFunctionConfiguration"
    ]
    resources = [
      "arn:aws:lambda:*:*:function:SecretsManager*"
    ]
  }
  statement {
    actions = [
      "secretsmanager:*"
    ]
    resources = [
      "arn:aws:secretsmanager:*:*:secret:rds/${var.environment}/*"
    ]
  }
}
