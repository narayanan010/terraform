locals {
  GitHubOrg = "capterra"
  GitHubRepo = [
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
  name               = "github-actions-${var.application}-${var.environment}"
  description        = "Role permissions for ${var.application} actions"
  assume_role_policy = data.aws_iam_policy_document.codedeploy.json
}

resource "aws_iam_role_policy_attachment" "codedeploy_iam_role01" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

resource "aws_iam_role_policy_attachment" "codedeploy_iam_role02" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "codedeploy_iam_role03" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "codedeploy_iam_role04" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployFullAccess"
}

resource "aws_iam_role_policy_attachment" "codedeploy_iam_role05" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "codedeploy_iam_role06" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/ResourceGroupsandTagEditorFullAccess"
}

resource "aws_iam_role_policy_attachment" "codedeploy_iam_role07" {
  role       = aws_iam_role.github_actions.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_role_policy" "custom_inline_pol01" {
  name = "autoscaling_policy"
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

resource "aws_iam_role_policy" "custom_inline_pol02" {
  name = "custom_policy"
  role = aws_iam_role.github_actions.name

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "CognitoAccess",
          "Effect" : "Allow",
          "Action" : [
            "cognito-idp:AdminDeleteUser",
            "cognito-idp:ListUsersInGroup",
            "cognito-idp:AdminDeleteUserAttributes",
            "cognito-idp:AdminCreateUser",
            "cognito-idp:UpdateGroup",
            "cognito-idp:AdminDisableUser",
            "cognito-idp:AdminAddUserToGroup",
            "cognito-idp:AdminUpdateUserAttributes",
            "cognito-idp:AdminGetUser",
            "cognito-idp:ListUsers",
            "cognito-idp:DeleteUserAttributes",
            "cognito-idp:GetUser",
            "cognito-idp:UpdateUserAttributes",
            "cognito-idp:VerifyUserAttribute",
            "cognito-idp:DeleteUser",
            "cognito-idp:AdminSetUserPassword"
          ],
          "Resource" : "*",
          "Condition" : {
            "StringLike" : {
              "aws:ResourceTag/Team" : "Spacenine"
            }
          }
        },
        {
          "Sid" : "DynamoDBAccess",
          "Effect" : "Allow",
          "Action" : [
            "dynamodb:PutItem",
            "dynamodb:DeleteItem",
            "dynamodb:Scan",
            "dynamodb:UpdateItem",
            "dynamodb:BatchGet*",
            "dynamodb:BatchWrite*",
            "dynamodb:Describe*",
            "dynamodb:Get*",
            "dynamodb:Query"
          ],
          "Resource" : [
            "arn:aws:dynamodb:*:*:table/UserWorkspace*",
            "arn:aws:dynamodb:*:*:table/userworkspace*"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "custom_inline_pol03" {
  name = "ses_policy"
  role = aws_iam_role.github_actions.name

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "AuthorizeFromAddress",
          "Effect" : "Allow",
          "Action" : [
            "ses:SendEmail",
            "ses:SendRawEmail"
          ],
          "Resource" : "*",
          "Condition" : {
            "StringEquals" : {
              "ses:FromAddress" : "software@capterra.com"
            }
          }
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "custom_inline_pol04" {
  name = "cognito_identity_policy"
  role = aws_iam_role.github_actions.name

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "cognitoidentity01",
          "Effect" : "Allow",
          "Action" : "cognito-identity:GetOpenIdTokenForDeveloperIdentity",
          "Resource" : "arn:aws:cognito-identity:us-east-1:296947561675:identitypool/us-east-1:c08914fc-fa28-4e42-a815-b892e8220e22"
        },
        {
          "Sid" : "cognitoidentity02",
          "Effect" : "Allow",
          "Action" : "cognito-identity:GetOpenIdToken",
          "Resource" : "*"
        }
      ]
    }
  )
}

