locals {
  GitHubOrg = "capterra"
  GitHubRepos = [
    "autobidder"
  ]
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "github_actions_assume_role_autobidder" {

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

resource "aws_iam_role" "github_actions_autobidder" {
  name               = "github-actions-${var.application}-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role_autobidder.json
}

data "aws_iam_policy_document" "github_actions_autobidder" {
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
    resources = ["arn:aws:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:repository/*"]
    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/repository"
      values   = ["autobidder"]
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

resource "aws_iam_policy" "github_actions_autobidder" {
  name        = "github-actions-${var.application}-${var.environment}"
  description = "Grant Github Actions defined scope of AWS actions"
  policy      = data.aws_iam_policy_document.github_actions_autobidder.json
}

resource "aws_iam_role_policy_attachment" "github_actions_autobidder" {
  role       = aws_iam_role.github_actions_autobidder.name
  policy_arn = aws_iam_policy.github_actions_autobidder.arn
}


# resource "aws_iam_role_policy" "github_actions_autobidder_pol01" {
#   name       = "eks_policy"
#   role       = aws_iam_role.github_actions_autobidder.name

#   policy = jsonencode(
#     {
#       "Version" : "2012-10-17",
#       "Statement" : [
#         {
#           "Sid": "EKSreadonly",
#           "Action": [
#               "eks:UntagResource",
#               "eks:TagResource",
#               "eks:ListUpdates",
#               "eks:ListTagsForResource",
#               "eks:ListNodegroups",
#               "eks:ListIdentityProviderConfigs",
#               "eks:ListFargateProfiles",
#               "eks:ListClusters",
#               "eks:ListAddons",
#               "eks:DescribeUpdate",
#               "eks:DescribeNodegroup",
#               "eks:DescribeIdentityProviderConfig",
#               "eks:DescribeFargateProfile",
#               "eks:DescribeCluster",
#               "eks:DescribeAddonVersions",
#               "eks:DescribeAddon",
#               "eks:AccessKubernetesApi"
#           ],
#           "Effect": "Allow",
#           "Resource": [
#               "arn:aws:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster/capterra-staging-eks",
#               "arn:aws:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:addon/capterra-staging-eks/*/*",
#               "arn:aws:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:fargateprofile/capterra-staging-eks/*/*",
#               "arn:aws:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:nodegroup/capterra-staging-eks/*/*",
#               "arn:aws:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:identityproviderconfig/capterra-staging-eks/*/*/*"
#           ]
#         }
#       ]
#     }
#   )
# }


# resource "aws_iam_role_policy" "github_actions_autobidder_pol02" {
#   name       = "kms_policy1"
#   role       = aws_iam_role.github_actions_autobidder.name

#   policy = jsonencode(
#     {
#       "Version" : "2012-10-17",
#       "Statement" : [
#         {
#           "Sid": "KMSmanage",
#           "Action": [
#             "kms:GetParametersForImport",
#             "kms:Decrypt",
#             "kms:ListKeyPolicies",
#             "kms:ListRetirableGrants",
#             "kms:GetKeyRotationStatus",
#             "kms:GetKeyPolicy",
#             "kms:DescribeKey",
#             "kms:ListResourceTags",
#             "kms:ListGrants",
#             "kms:Encrypt"
#           ],
#           "Effect": "Allow",
#           "Resource": [
#             "arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/f2d03108-d5ad-4db7-8b3d-2de72e3cdca0"
#           ]
#         }
#       ]
#     }
#   )
# }


# resource "aws_iam_role_policy" "github_actions_autobidder_pol03" {
#   name       = "kms_policy2"
#   role       = aws_iam_role.github_actions_autobidder.name

#   policy = jsonencode(
#     {
#       "Version" : "2012-10-17",
#       "Statement" : [
#         {
#           "Sid": "KMSreadonly",
#           "Action": [
#             "kms:DescribeCustomKeyStores",
#             "kms:ListKeys",
#             "kms:ListAliases"
#           ],
#           "Effect": "Allow",
#           "Resource": ["*"]
#         }
#       ]
#     }
#   )
# }