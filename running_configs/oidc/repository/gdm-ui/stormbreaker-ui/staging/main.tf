locals {
  GitHubOrg = "gdm-ui"
  GitHubRepo-stormbreaker = [
    "stormbreaker-ui"
  ]
}

data "aws_caller_identity" "current" {}
# data "aws_region" "current" {}

data "aws_iam_policy_document" "github_actions_assume_role_stormbreaker" {
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
      values   = [for repositories in toset(local.GitHubRepo-stormbreaker) : "repo:${local.GitHubOrg}/${repositories}:*"]
    }
  }
}

resource "aws_iam_role" "github_actions_stormbreaker" {
  name               = "github-actions-${var.product}-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role_stormbreaker.json
}

data "aws_iam_policy_document" "github_actions" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:DeleteObjectVersion",
      "s3:GetBucketLocation"
    ]
    resources = [
      "arn:aws:s3:::gdm-crf-staging-stormbreaker/*",
      "arn:aws:s3:::gdm-crf-staging-stormbreaker",
    ]
  }
  statement {
    actions = [
      "cloudfront:UpdateDistribution",
      "cloudfront:ListInvalidations",
      "cloudfront:GetInvalidation",
      "cloudfront:CreateInvalidation"
    ]
    resources = [
      "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/*"
    ]
  }
}

resource "aws_iam_policy" "github_actions_stormbreaker" {
  name        = "github-actions-${var.environment}-${var.product}"
  description = "Grant Github Actions defined scope of AWS actions"
  policy      = data.aws_iam_policy_document.github_actions.json
}

resource "aws_iam_role_policy_attachment" "github_actions_stormbreaker" {
  role       = aws_iam_role.github_actions_stormbreaker.name
  policy_arn = aws_iam_policy.github_actions_stormbreaker.arn
}
