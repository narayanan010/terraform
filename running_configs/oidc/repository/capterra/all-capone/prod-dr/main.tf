locals {
  GitHubOrg = "capterra"
  GitHubRepos = [
    "all-capone"
  ]
  route53_hostedzone = "Z30OS86JINAD69"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "github_actions_assume_role_cap_one_dr" {

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

resource "aws_iam_role" "github_actions_cap_one_dr" {
  name               = "github-actions-cap-one-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role_cap_one_dr.json
}

data "aws_iam_policy_document" "github_actions_cap_one_dr" {
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
    resources = ["arn:aws:ecr:${var.region}:${data.aws_caller_identity.current.account_id}:repository/capterra/*"]
    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/repository"
      values   = ["all-capone"]
    }
  }

  statement {
    actions = [
      "ecr:DescribeRegistry",
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "eks:ListNodegroups",
      "eks:DescribeFargateProfile",
      "eks:UntagResource",
      "eks:ListTagsForResource",
      "eks:ListAddons",
      "eks:DescribeAddon",
      "eks:ListFargateProfiles",
      "eks:DescribeNodegroup",
      "eks:DescribeIdentityProviderConfig",
      "eks:ListUpdates",
      "eks:DescribeUpdate",
      "eks:TagResource",
      "eks:AccessKubernetesApi",
      "eks:DescribeCluster",
      "eks:ListClusters",
      "eks:DescribeAddonVersions",
      "eks:ListIdentityProviderConfigs"
    ]
    resources = [
      "arn:aws:eks:${var.region}:${data.aws_caller_identity.current.account_id}:cluster/capterra-production-eks-dr",
      "arn:aws:eks:${var.region}:${data.aws_caller_identity.current.account_id}:addon/capterra-production-eks-dr/*/*",
      "arn:aws:eks:${var.region}:${data.aws_caller_identity.current.account_id}:fargateprofile/capterra-production-eks-dr/*/*",
      "arn:aws:eks:${var.region}:${data.aws_caller_identity.current.account_id}:nodegroup/capterra-production-eks-dr/*/*",
      "arn:aws:eks:${var.region}:${data.aws_caller_identity.current.account_id}:identityproviderconfig/capterra-production-eks-dr/*/*/*"]
  }

  statement {
    actions = [
      "kms:GetParametersForImport",
      "kms:Decrypt",
      "kms:ListKeyPolicies",
      "kms:ListRetirableGrants",
      "kms:GetKeyRotationStatus",
      "kms:GetKeyPolicy",
      "kms:DescribeKey",
      "kms:ListResourceTags",
      "kms:ListGrants",
      "kms:Encrypt"
    ]
    resources = ["arn:aws:kms:us-west-2:176540105868:key/d212578c-5858-48e8-a473-f5d17654c796"]
  }

  statement {
    actions = [
      "kms:DescribeCustomKeyStores",
      "kms:ListKeys",
      "kms:ListAliases"
    ]
    resources = ["*"]
  }

  # PR DNS Cleanup
  statement {
    actions = [
      "route53:ListTagsForResources",
      "route53:GetHostedZone",
      "route53:ListResourceRecordSets",
      "route53:GetHealthCheck",
      "route53:GetHostedZoneLimit",
      "route53:ListTagsForResource"
    ]
    resources = ["arn:aws:route53:::hostedzone/${local.route53_hostedzone}"]
  }

  statement {
    actions = [
      "route53:ListHealthChecks",
      "route53:ListHostedZones",
      "route53:GetHostedZoneCount",
      "route53:ListHostedZonesByName"
    ]
    resources = ["*"]
  }

  statement {
    actions   = ["route53:ChangeResourceRecordSets"]
    resources = ["arn:aws:route53:::hostedzone/${local.route53_hostedzone}"]
  }
}

resource "aws_iam_policy" "github_actions_cap_one_dr" {
  name        = "github-actions-cap-one-${var.environment}"
  description = "Grant Github Actions defined scope of AWS actions"
  policy      = data.aws_iam_policy_document.github_actions_cap_one_dr.json
}

resource "aws_iam_role_policy_attachment" "github_actions_cap_one_dr" {
  role       = aws_iam_role.github_actions_cap_one_dr.name
  policy_arn = aws_iam_policy.github_actions_cap_one_dr.arn
}
