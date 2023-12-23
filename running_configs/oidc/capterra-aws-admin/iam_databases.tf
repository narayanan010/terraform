data "aws_iam_policy_document" "databases_deployer_github_actions_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.githuboidc.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [for repositories in toset(local.GitHubDatabaseRepo) : "repo:${local.GitHubOrg}/${repositories}:*"]
    }
  }
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/github-actions-database-deployer"]
    }
  }
}

resource "aws_iam_role" "databases_deployer_github_actions" {
  name               = "github-actions-database-deployer"
  assume_role_policy = data.aws_iam_policy_document.databases_deployer_github_actions_assume_role.json

  lifecycle {
    ignore_changes = [
      tags,
      tags_all
    ]
  }
}

data "aws_iam_policy_document" "databases_deployer_github_actions" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:ListAllMyBuckets",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:GetBucketPolicy",
      "s3:PutBucketPolicy",
      "s3:GetBucketLocation",
      "s3:CreateBucket",
      "s3:ListBucketVersions",
      "s3:GetBucketVersioning",
      "s3:PutBucketAcl",
      "s3:PutBucketObjectLockConfiguration",
      "s3:PutBucketVersioning",
    ]
    resources = [
      "arn:aws:s3:::${local.TerraformStateBucket}/*",
      "arn:aws:s3:::${local.TerraformStateBucket}",
    ]
  }

  statement {
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:DescribeTable",
    ]
    resources = [
      "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${local.DynamodbTable}",
    ]
  }

  statement { # when OIDC use role_session & iam user together
    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
    resources = [
      "arn:aws:iam::*:role/github-actions-db-deployer-*",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.databases_deployer_github_actions.name}",   # When is used without parameter 'role-session-name'
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.databases_deployer_github_actions.name}/*", # When is used with parameter 'role-session-name'
    ]
  }

  statement {
    actions = [
      "iam:GetGroup",
      "iam:GetGroupPolicy",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:ListAttachedGroupPolicies",
      "iam:ListGroupPolicies",
      "iam:ListGroups",
      "iam:AddUserToGroup",
      "iam:CreateGroup",
      "iam:RemoveUserFromGroup",
      "iam:DeleteGroup",
      "iam:AttachGroupPolicy",
      "iam:UpdateGroup",
      "iam:DetachGroupPolicy",
      "iam:DeleteGroupPolicy",
      "iam:PutGroupPolicy",
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:group/*",
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.databases_deployer_github_actions.name}",
    ]
  }
}
resource "aws_iam_policy" "databases_deployer_github_actions" {
  name        = "github-actions-database-deployer"
  description = "Grant Github Actions defined scope of AWS actions"
  policy      = data.aws_iam_policy_document.databases_deployer_github_actions.json
}

resource "aws_iam_role_policy_attachment" "databases_deployer_github_actions" {
  role       = aws_iam_role.databases_deployer_github_actions.name
  policy_arn = aws_iam_policy.databases_deployer_github_actions.arn
}

resource "aws_iam_role_policy" "databases_deployer_github_actions_policy1" {
  name = "capterra-terraform-repository-gha-state-deploy-policy"
  role = aws_iam_role.databases_deployer_github_actions.name
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : [
            "s3:PutObject",
            "s3:GetObject",
            "s3:ListBucket",
            "s3:DeleteObject"
          ],
          "Resource" : [
            "arn:aws:s3:::capterra-terraform-repository-gha-state-deploy",
            "arn:aws:s3:::capterra-terraform-repository-gha-state-deploy/*"
          ]
        },
        {
          "Sid" : "VisualEditor1",
          "Effect" : "Allow",
          "Action" : [
            "dynamodb:BatchWriteItem",
            "dynamodb:DeleteItem",
            "dynamodb:GetItem",
            "dynamodb:PutItem",
            "dynamodb:Query",
            "dynamodb:Scan",
            "dynamodb:UpdateItem"
          ],
          "Resource" : [
            "arn:aws:dynamodb:*:237884149494:table/capterra-terraform-repository-automation-state"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "databases_deployer_github_actions_policy2" {
  name = "capterra-iam_permission"
  role = aws_iam_role.databases_deployer_github_actions.name
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : "iam:ListAccountAliases",
          "Resource" : "*"
        }
      ]
    }
  )
}
