locals {
  GitHubOrg = "capterra"
  GitHubRepos = [
    "clicks-streaming"
  ]
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "github_actions_assume_role_clicks_streaming" {

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"]
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

resource "aws_iam_role" "github_actions_clicks_streaming" {
  name               = "github-actions-${var.application}-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role_clicks_streaming.json
}

data "aws_iam_policy_document" "github_actions_clicks_streaming" {

  statement {
    actions = [
      "ecr:UntagResource",
      "ecr:GetDownloadUrlForLayer",
      "ecr:CompleteLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:InitiateLayerUpload",
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:TagResource",
      "ecr:ListTagsForResource",
      "ecr:PutImage",
      "ecr:GetAuthorizationToken"
    ]
    resources = ["arn:aws:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:repository/*"]
    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/repository"
      values   = ["clicks-streaming"]
    }
  }

  statement {
    actions = [
      "ecr:DescribeRegistry",
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "github_actions_clicks_streaming" {
  name        = "github-actions-${var.application}-${var.environment}"
  description = "Grant Github Actions defined scope of AWS actions"
  policy      = data.aws_iam_policy_document.github_actions_clicks_streaming.json
}

resource "aws_iam_role_policy_attachment" "github_actions_clicks_streaming" {
  role       = aws_iam_role.github_actions_clicks_streaming.name
  policy_arn = aws_iam_policy.github_actions_clicks_streaming.arn
}
