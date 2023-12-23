locals {
  GitHubOrg = "capterra"
  GitHubRepos = [
    "capterra-eks"
  ]
  eks_environments = ["production-dr"]
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "eks_main_roles_trusted_policy" {

  statement {
    sid     = "GitHubActions"
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

  statement {
    sid     = "AssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::237884149494:root"]
    }
  }
}

resource "aws_iam_role" "eks_main_roles" {
  for_each = toset(local.eks_environments)

  name               = "assume-eks-${each.key}-cluster-admin"
  description        = "This role will have cluster admin access over production-dr EKS cluster"
  assume_role_policy = data.aws_iam_policy_document.eks_main_roles_trusted_policy.json

  tags = {
    cluster = "capterra-production-eks-dr"
  }
}


data "aws_iam_policy_document" "eks_main_roles_policy" {
  for_each = toset(local.eks_environments)

  statement {
    actions = [
      "eks:ListNodegroups",
      "eks:DescribeFargateProfile",
      "eks:ListTagsForResource",
      "eks:ListAddons",
      "eks:DescribeAddon",
      "eks:ListFargateProfiles",
      "eks:DescribeNodegroup",
      "eks:DescribeIdentityProviderConfig",
      "eks:ListUpdates",
      "eks:DescribeUpdate",
      "eks:AccessKubernetesApi",
      "eks:DescribeCluster",
      "eks:ListIdentityProviderConfigs"
    ]
    resources = [
      "arn:aws:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster/capterra-production-eks-dr",
    ]
  }

  statement {
    actions = [
      "eks:ListClusters"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "eks_main_roles" {
  for_each = toset(local.eks_environments)

  name        = "eks-kubeconfig-describe-${each.key}-cluster-eks"
  description = "This role will have cluster admin access over ${each.key} EKS cluster"
  policy      = data.aws_iam_policy_document.eks_main_roles_policy[each.key].json
}

resource "aws_iam_role_policy_attachment" "eks_main_roles" {
  for_each = toset(local.eks_environments)

  role       = aws_iam_role.eks_main_roles[each.key].name
  policy_arn = aws_iam_policy.eks_main_roles[each.key].arn
}
