locals {
  GitHubOrg = "capterra"
  GitHubRepo = [
    "terraform-poc",
    "terraform"
  ]
}

data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    sid     = "CodeDeployActions"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }

  statement {
    sid     = "GitHubActions"
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"
      identifiers = [data.terraform_remote_state.common_resources.outputs.githuboidc_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [for repositories in toset(local.GitHubRepo) : "repo:${local.GitHubOrg}/${repositories}:*"]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name               = "github-actions-${var.product}-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ecr_fullaccess" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "codedploy_iam_role02" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy" "codedploy_inline_pol01" {
  name       = "autoscaling_policy"
  role       = aws_iam_role.github_actions.name

  policy = jsonencode(
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": [
                    "autoscaling:*",
                    "elasticloadbalancing:*",
                    "application-autoscaling:*",
                    "resource-groups:*"
                ],
                "Effect": "Allow",
                "Resource": "*"
            }
        ]
    }
  )
}

