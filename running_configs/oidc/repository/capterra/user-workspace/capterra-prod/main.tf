locals {
  GitHubOrg = "capterra"
  GitHubRepos = [
    "user-workspace"
  ]
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_iam_role" "github_actions_user_workspace" {
  name               = "github-actions-${var.application}-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role_user_workspace.json
}

data "aws_iam_policy_document" "github_actions_assume_role_user_workspace" {

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

# Customer managed Policy
data "aws_iam_policy_document" "github_actions_user_workspace" {
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
      "ecr:PutImage"
    ]
    resources = ["arn:aws:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:repository/capterra/*"]
    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/repository"
      values   = ["user-workspace"]
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

resource "aws_iam_policy" "github_actions_user_workspace" {
  name        = "github-actions-${var.application}-${var.environment}"
  description = "Grant Github Actions defined scope of AWS actions"
  policy      = data.aws_iam_policy_document.github_actions_user_workspace.json
}

resource "aws_iam_role_policy_attachment" "github_actions_user_workspace" {
  role       = aws_iam_role.github_actions_user_workspace.name
  policy_arn = aws_iam_policy.github_actions_user_workspace.arn
}
