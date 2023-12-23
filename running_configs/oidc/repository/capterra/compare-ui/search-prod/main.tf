locals {
  GitHubOrg = "capterra"
  GitHubRepos = [
    "compare-ui"
  ]
}

data "aws_caller_identity" "current" {}
data "aws_iam_policy_document" "github_actions_assume_role_compare_ui" {

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.aws_iam_openid_connect_provider_github_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [for repositories in toset(local.GitHubRepos) : "repo:${local.GitHubOrg}/${repositories}:*"]
    }
  }
}

resource "aws_iam_role" "github_actions_compare_ui" {
  name               = "github-actions-${var.application}-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role_compare_ui.json
}

data "aws_iam_policy_document" "github_actions_compare_ui" {
  # Difficult to efficiently limit apigateway
  statement {
    actions = [
      "apigateway:GET"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "apigateway:*"
    ]
    resources = [
      "arn:aws:apigateway:*::/restapis",
      "arn:aws:apigateway:*::/restapis/*/stages/prod*",
      "arn:aws:apigateway:*::/restapis/*/stages/prod",
      "arn:aws:apigateway:*::/restapis/*/resources/*/methods/*",
      "arn:aws:apigateway:*::/restapis/*/resources/*",
      "arn:aws:apigateway:*::/restapis/*/deployments/*",
      "arn:aws:apigateway:*::/restapis/*",
      "arn:aws:apigateway:*::/tags",
      "arn:aws:apigateway:*::/tags/*"
    ]
  }

  statement {
    actions = [
      "cloudfront:GetInvalidation",
      "cloudformation:CreateStack",
      "cloudformation:DescribeStacks",
      "cloudformation:ValidateTemplate",
      "cloudformation:ListStacks",
      "cloudfront:CreateInvalidation"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "cloudformation:SetStackPolicy",
      "cloudformation:DescribeStackResources",
      "cloudformation:UpdateTerminationProtection",
      "cloudformation:DescribeStackResource",
      "cloudformation:CreateChangeSet",
      "cloudformation:DeleteChangeSet",
      "cloudformation:DescribeStackEvents",
      "cloudformation:GetTemplate",
      "cloudformation:DeleteStack",
      "cloudformation:UpdateStack",
      "cloudformation:DescribeChangeSet",
      "cloudformation:ExecuteChangeSet",
      "cloudformation:ListStackResources"
    ]
    resources = [
      "arn:aws:cloudformation:*:${data.aws_caller_identity.current.account_id}:stack/capterra-${var.application}*/*",
      "arn:aws:cloudformation:*:${data.aws_caller_identity.current.account_id}:stack/capterra-${var.application}-service-prod/*"
    ]
  }

  statement {
    actions   = ["iam:CreateServiceLinkedRole"]
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/ops.apigateway.amazonaws.com/AWSServiceRoleForAPIGateway"]
  }

  statement {
    actions = [
      "iam:UpdateAssumeRolePolicy",
      "iam:ListRoleTags",
      "iam:UntagRole",
      "iam:TagRole",
      "iam:CreateRole",
      "iam:PassRole",
      "iam:AttachRolePolicy",
      "iam:PutRolePolicy",
      "iam:DetachRolePolicy",
      "iam:ListAttachedRolePolicies",
      "iam:DeleteRolePolicy",
      "iam:ListRolePolicies",
      "iam:GetRole",
      "iam:UpdateRoleDescription",
      "iam:DeleteRole",
      "iam:UpdateRole",
      "iam:GetRolePolicy"
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/capterra-${var.application}*",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/capterra-${var.application}",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/NewRelicLambdaIntegrationRole_151038"
      ]
  }

  statement {
    actions = [
      "lambda:ListFunctions",
      "lambda:ListEventSourceMappings",
      "lambda:ListLayerVersions",
      "lambda:ListLayers",
      "lambda:GetAccountSettings",
      "lambda:CreateEventSourceMapping",
      "lambda:ListCodeSigningConfigs",
      "lambda:CreateCodeSigningConfig",
      "lambda:CreateFunction",
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "lambda:List*",
      "lambda:Update*",
      "lambda:Add*",
      "lambda:Delete*",
      "lambda:Get*",
      "lambda:Publish*",
      "lambda:Put*",
      "lambda:Tag*",
      "lambda:Untag*",
      "lambda:Remove*",
      "lambda:Invoke*"
    ]
    resources = [
      "arn:aws:lambda:*:*:layer:*",
      "arn:aws:lambda:*:${data.aws_caller_identity.current.account_id}:function:capterra-${var.application}*",
      "arn:aws:lambda:*:${data.aws_caller_identity.current.account_id}:function:capterra-${var.application}*:*",
      "arn:aws:lambda:*:*:function:newrelic*"
    ]
  }

  statement {
    actions = [
      "s3:ListBucket",
      "s3:Put*",
      "s3:Get*",
      "s3:Delete*",
      "s3:Create*",
    ]
    resources = [
      "arn:aws:s3:::capterra-${var.application}*",
      "arn:aws:s3:::capterra-${var.application}*/*",
      "arn:aws:s3:::${var.application}*",
      "arn:aws:s3:::${var.application}*/*",
    ]
  }

    statement {
    actions = [
      "s3:ListBucket",
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetBucketLocation",
      "s3:DeleteObject",
    ]
    resources = [
      "arn:aws:s3:::capterra-serverless-${data.aws_caller_identity.current.account_id}",
      "arn:aws:s3:::capterra-serverless-${data.aws_caller_identity.current.account_id}/*",
      "arn:aws:s3:::capterra-serverless-${data.aws_caller_identity.current.account_id}-us-east-1",
      "arn:aws:s3:::capterra-serverless-${data.aws_caller_identity.current.account_id}-us-east-1/*",
      "arn:aws:s3:::capterra-serverless-${data.aws_caller_identity.current.account_id}-us-west-2",
      "arn:aws:s3:::capterra-serverless-${data.aws_caller_identity.current.account_id}-us-west-2/*"
    ]
  }

  statement {
    actions = [
      "s3:ListAllMyBuckets"
    ]
    resources = ["*"]
  }


  statement {
    actions = [
      "ec2:Describe*"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "logs:TagLogGroup",
      "logs:Describe*",
      "logs:UntagLogGroup",
      "logs:DeleteLogGroup",
      "logs:CreateLogGroup",
      "logs:PutSubscriptionFilter",
      "logs:DeleteSubscriptionFilter"
    ]
    resources = [
      "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/capterra-${var.application}*",
      "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:/aws/api-gateway/capterra-${var.application}*",
      "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/capterra-${var.application}*:log-stream:*",
      "arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:/aws/api-gateway/capterra-${var.application}*:log-stream*"
    ]
  }

  statement {
    actions = [
      "waf:ListWebACLs",
      "waf-regional:ListWebACLs",
      "wafv2:ListWebACLs"
    ]
    resources = ["*"]
  }
  
  statement {
    actions = ["wafv2:AssociateWebACL"]    
    resources = [
      "arn:aws:apigateway:*::/restapis/*/prod/*",
      "arn:aws:wafv2:*:296947561675:*/webacl/*/*"
    ]
  }
}

resource "aws_iam_policy" "github_actions_compare_ui" {
  name        = "github-actions-${var.application}-${var.environment}"
  description = "Grant Github Actions defined scope of AWS actions"
  policy      = data.aws_iam_policy_document.github_actions_compare_ui.json
}

resource "aws_iam_role_policy_attachment" "github_actions_compare_ui" {
  role       = aws_iam_role.github_actions_compare_ui.name
  policy_arn = aws_iam_policy.github_actions_compare_ui.arn
}
