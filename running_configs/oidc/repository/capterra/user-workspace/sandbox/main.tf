locals {
  GitHubOrg = "capterra"
  GitHubRepo = [
    "terraform-poc",
    "terraform",
    "user-workspace"
  ]
}

data "aws_iam_policy_document" "codedeploy" {
  statement {
    sid     = "ECSpermission"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "codedeploy.amazonaws.com",
        "ecs-tasks.amazonaws.com",
        "ecs.amazonaws.com"
      ]
    }
  }
  statement {
    sid     = "GitHubActions"
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
      values   = [for repositories in toset(local.GitHubRepo) : "repo:${local.GitHubOrg}/${repositories}:*"]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name               = "github-actions-${var.product}-${var.environment}"
  description        = "Role permissions for CodeDeploy actions"
  assume_role_policy = data.aws_iam_policy_document.codedeploy.json
}

resource "aws_iam_role_policy_attachment" "codedploy_iam_role01" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

resource "aws_iam_role_policy_attachment" "codedploy_iam_role02" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "codedploy_iam_role03" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "codedploy_iam_role04" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess"
}

resource "aws_iam_role_policy_attachment" "codedploy_iam_role05" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "codedploy_iam_role06" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/ResourceGroupsandTagEditorFullAccess"
}

# resource "aws_iam_role_policy" "codedploy_inline_pol01" {
#   name = "codedeploy_pol"
#   role = aws_iam_role.github_actions.name

#   policy = jsonencode(
#     {
#       "Version" : "2012-10-17",
#       "Statement" : [
#         {
#           "Sid" : "AllowAllCodeDeploy",
#           "Effect" : "Allow",
#           "Action" : [
#             "codedeploy:*"
#           ],
#           "Resource" : [
#             "arn:aws:codedeploy:*:${data.aws_caller_identity.current.account_id}:*"
#           ]
#         }
#       ]
#     }
#   )
# }

resource "aws_iam_role_policy" "codedploy_inline_pol02" {
  name = "autoscaling_pol"
  role = aws_iam_role.github_actions.name

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : [
            "application-autoscaling:*",
            "autoscaling-plans:*",
            "autoscaling:*",
            "elasticloadbalancing:*",
            "resource-groups:*"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}

# resource "aws_iam_role_policy" "codedploy_inline_pol03" {
#   name = "ec2_pol"
#   role = aws_iam_role.github_actions.name

#   policy = jsonencode(
#     {
#       "Version" : "2012-10-17",
#       "Statement" : [
#         {
#           "Sid" : "VisualEditor0",
#           "Effect" : "Allow",
#           "Action" : "ec2:*",
#           "Resource" : "arn:aws:ec2:${data.aws_region.current.name}::image/ami-*"
#         }
#       ]
#     }
#   )
# }
