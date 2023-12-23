locals {
  GitHubOrg = "capterra"
  GitHubRepos = [
    "services-ui"
  ]
  route53_hostedzone = "Z30OS86JINAD69"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "github_actions_assume_role_services_ui" {

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
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
      values   = [for repositories in toset(local.GitHubRepos) : "repo:${local.GitHubOrg}/${repositories}:*"]
    }
  }
}

resource "aws_iam_role" "github_actions_services_ui" {
  name               = "github-actions-${var.application}-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role_services_ui.json
}

# Customer managed Policy
data "aws_iam_policy_document" "github_actions_services_ui" {
  statement {
    actions = [
      "route53:ListTagsForResources",
      "route53:GetHostedZone",
      "route53:ListResourceRecordSets",
      "route53:GetHealthCheck",
      "route53:GetHostedZoneLimit",
      "route53:ChangeResourceRecordSets",
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
      values   = ["services-ui"]
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
      "arn:aws:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster/capterra-production-eks-dr",
      "arn:aws:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster/capterra-production-eks-dr/*/*"
    ]
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
    resources = ["arn:aws:kms:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:key/d212578c-5858-48e8-a473-f5d17654c796"]
  }

  statement {
    actions = [
      "kms:DescribeCustomKeyStores",
      "kms:ListKeys",
      "kms:ListAliases"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "github_actions_services_ui" {
  name        = "github-actions-${var.application}-${var.environment}"
  description = "Grant Github Actions defined scope of AWS actions"
  policy      = data.aws_iam_policy_document.github_actions_services_ui.json
}

resource "aws_iam_role_policy_attachment" "github_actions_services_ui" {
  role       = aws_iam_role.github_actions_services_ui.name
  policy_arn = aws_iam_policy.github_actions_services_ui.arn
}
