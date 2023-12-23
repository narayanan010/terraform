locals {
  GitHubOrg = "capterra"
  GitHubRepos = [
    "blog-ui"
  ]
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "github_actions_assume_role_blog_ui" {

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

resource "aws_iam_role" "github_actions_blog_ui" {
  name               = "github-actions-blog-ui-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role_blog_ui.json
}

data "aws_iam_policy_document" "github_actions_blog_ui" {
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
      "arn:aws:apigateway:*::/restapis/*/stages/staging*",
      "arn:aws:apigateway:*::/restapis/*/stages/staging",
      "arn:aws:apigateway:*::/restapis/*/resources/*/methods/*",
      "arn:aws:apigateway:*::/restapis/*/resources/*",
      "arn:aws:apigateway:*::/restapis/*/deployments/*",
      "arn:aws:apigateway:*::/restapis/*",
      "arn:aws:apigateway:*::/tags",
      "arn:aws:apigateway:*::/tags/*",
      "arn:aws:apigateway:*::/domainnames",
      "arn:aws:apigateway:*::/domainnames/api.resources.capstage.net",
      "arn:aws:apigateway:*::/domainnames/*api.resources.capstage.net",
      "arn:aws:apigateway:*::/domainnames/api.resources.capstage.net/apimappings",
      "arn:aws:apigateway:*::/domainnames/*api.resources.capstage.net/apimappings",
      "arn:aws:apigateway:*::/domainnames/api.resources.capstage.net/apimappings/*",
      "arn:aws:apigateway:*::/domainnames/*api.resources.capstage.net/apimappings/*"
    ]
  }

  statement {
    actions = [
      "cloudfront:UpdateDistribution",
      "wafv2:ListWebACLs"
    ]
    resources = ["*"]
  }


  statement {
    actions = [
      "wafv2:AssociateWebACL",
      "wafv2:DisassociateWebACL"
    ]
    resources = [
      "arn:aws:apigateway:${data.aws_region.current.name}::/restapis/*/stages/staging*",
      "arn:aws:apigateway:${data.aws_region.current.name}::/restapis/*/stages/staging",
    "arn:aws:wafv2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*/webacl/capterra-blog-api-staging-waf/*"]
  }

  statement {
    actions   = ["route53:ChangeResourceRecordSets"]
    resources = ["arn:aws:route53:::hostedzone/Z735WTNG1JTY0"]
  }

  statement {
    actions = [
      "cloudformation:CreateStack",
      "cloudformation:DescribeStacks",
      "cloudformation:ValidateTemplate",
      "cloudformation:ListStacks",
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
      "arn:aws:cloudformation:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:stack/blog-ui-cf-maintainer-api-staging*/*",
      "arn:aws:cloudformation:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:stack/blog-ui-cf-maintainer-api-staging/*"
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
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/blog-ui-cf-maintainer-api-staging*",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/blog-ui-cf-maintainer-api-staging"]
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
    ]
    resources = [
      "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:blog-ui-cf-maintainer-api-staging*",
      "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:blog-ui-cf-maintainer-api-staging*:*",
      "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:blog-ui-cf-maintainer-api-staging",
      "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:blog-ui-cf-maintainer-api-staging:*"
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
      "logs:TagLogGroup",
      "logs:DescribeLogGroups",
      "logs:UntagLogGroup",
      "logs:DeleteLogGroup",
      "logs:CreateLogGroup",
    ]
    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:blog-ui-cf-maintainer-api-staging*",
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/blog-ui-cf-maintainer-api-staging*",
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:blog-ui-cf-maintainer-api-staging",
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/blog-ui-cf-maintainer-api-staging",
    ]
  }
}

resource "aws_iam_policy" "github_actions_blog_ui" {
  name        = "github-actions-${var.application}-${var.environment}"
  description = "Grant Github Actions defined scope of AWS actions"
  policy      = data.aws_iam_policy_document.github_actions_blog_ui.json
}

resource "aws_iam_role_policy_attachment" "github_actions_blog_ui" {
  role       = aws_iam_role.github_actions_blog_ui.name
  policy_arn = aws_iam_policy.github_actions_blog_ui.arn
}
