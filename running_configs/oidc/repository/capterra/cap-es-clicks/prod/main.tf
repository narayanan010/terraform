locals {
  GitHubOrg = "capterra"
  GitHubRepos = [
    "cap-es-clicks"
  ]
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "github_actions_assume_role_cap_es_clicks" {

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

resource "aws_iam_role" "github_actions_cap_es_clicks" {
  name               = "github-actions-cap-es-clicks-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role_cap_es_clicks.json
}

data "aws_iam_policy_document" "github_actions_cap_es_clicks" {
  statement {
    actions = [
      "ssm:CancelCommand",
      "ssm:ListCommands",
      "ssm:ListCommandInvocations",
      "ssm:GetCommandInvocation"
    ]
    resources = ["*"]
  }

  statement {
    actions   = ["ssm:SendCommand"]
    resources = [
          "arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:managed-instance/i-0e6c35f4f5a3d0cb4",
          "arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:managed-instance/i-0c3cfdb1baba99987",
          "arn:aws:s3:::capterra-ssm-command-logs-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}",
          "arn:aws:ssm:*:${data.aws_caller_identity.current.account_id}:document/Capterra-CapEsClicks-${var.environment}-*",
          "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:instance/i-0e6c35f4f5a3d0cb4",
          "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:instance/i-0c3cfdb1baba99987"
        ]
  }
}

resource "aws_iam_policy" "github_actions_cap_es_clicks" {
  name        = "github-actions-cap-es-clicks-${var.environment}"
  description = "Grant Github Actions defined scope of AWS actions"
  policy      = data.aws_iam_policy_document.github_actions_cap_es_clicks.json
}

resource "aws_iam_role_policy_attachment" "github_actions_cap_es_clicks" {
  role       = aws_iam_role.github_actions_cap_es_clicks.name
  policy_arn = aws_iam_policy.github_actions_cap_es_clicks.arn
}
