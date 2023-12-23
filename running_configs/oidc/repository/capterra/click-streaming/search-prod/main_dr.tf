data "aws_caller_identity" "region_dr" {
  provider = aws.region_dr
}

data "aws_region" "region_dr" {
  provider = aws.region_dr
}

data "aws_iam_policy_document" "github_actions_clicks_streaming_dr" {
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
      "arn:aws:cloudformation:${data.aws_region.region_dr.name}:${data.aws_caller_identity.region_dr.account_id}:stack/capterra-clicks-*/*",
      "arn:aws:cloudformation:${data.aws_region.region_dr.name}:${data.aws_caller_identity.region_dr.account_id}:stack/capterra-clicks-service-prod/*"
    ]
  }

  statement {
    actions   = ["iam:CreateServiceLinkedRole"]
    resources = ["arn:aws:iam::${data.aws_caller_identity.region_dr.account_id}:role/aws-service-role/ops.apigateway.amazonaws.com/AWSServiceRoleForAPIGateway"]
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
      "arn:aws:iam::${data.aws_caller_identity.region_dr.account_id}:role/capterra-clicks*",
      "arn:aws:iam::${data.aws_caller_identity.region_dr.account_id}:role/capterra-clicks"
    ]
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
      "arn:aws:lambda:${data.aws_region.region_dr.name}:${data.aws_caller_identity.region_dr.account_id}:function:capterra-clicks*",
      "arn:aws:lambda:${data.aws_region.region_dr.name}:${data.aws_caller_identity.region_dr.account_id}:function:capterra-clicks*:*",
      "arn:aws:lambda:*:*:function:newrelic*"
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
      "arn:aws:s3:::capterra-serverless-${data.aws_caller_identity.region_dr.account_id}",
      "arn:aws:s3:::capterra-serverless-${data.aws_caller_identity.region_dr.account_id}/*",
      "arn:aws:s3:::capterra-serverless-${data.aws_caller_identity.region_dr.account_id}-us-east-1",
      "arn:aws:s3:::capterra-serverless-${data.aws_caller_identity.region_dr.account_id}-us-east-1/*",
      "arn:aws:s3:::capterra-serverless-${data.aws_caller_identity.region_dr.account_id}-us-west-2",
      "arn:aws:s3:::capterra-serverless-${data.aws_caller_identity.region_dr.account_id}-us-west-2/*"
    ]
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
      "arn:aws:logs:${data.aws_region.region_dr.name}:${data.aws_caller_identity.region_dr.account_id}:log-group:/aws/lambda/capterra-clicks*",
      "arn:aws:logs:${data.aws_region.region_dr.name}:${data.aws_caller_identity.region_dr.account_id}:log-group:/aws/api-gateway/capterra-clicks*",
      "arn:aws:logs:${data.aws_region.region_dr.name}:${data.aws_caller_identity.region_dr.account_id}:log-group:/aws/lambda/capterra-clicks*:log-stream:*",
      "arn:aws:logs:${data.aws_region.region_dr.name}:${data.aws_caller_identity.region_dr.account_id}:log-group:/aws/api-gateway/capterra-clicks*:log-stream*"
    ]
  }
}


resource "aws_iam_policy" "github_actions_clicks_streaming_dr" {
  name        = "github-actions-${var.application}-${var.environment}-dr"
  description = "Grant Github Actions defined scope of AWS actions for ${var.environment}-dr"
  policy      = data.aws_iam_policy_document.github_actions_clicks_streaming_dr.json

  tags = {
    region              = var.region_dr
    environment         = "prod-dr"
    network_environment = "prod-dr"
    app_environment     = "prod-dr"
    created_by          = "dan.oliva@gartner.com"
  }
}

resource "aws_iam_role_policy_attachment" "github_actions_clicks_streaming_dr" {
  role       = aws_iam_role.github_actions_clicks_streaming.name
  policy_arn = aws_iam_policy.github_actions_clicks_streaming_dr.arn
}
