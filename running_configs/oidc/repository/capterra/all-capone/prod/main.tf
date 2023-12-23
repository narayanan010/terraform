locals {
  GitHubOrg = "capterra"
  GitHubRepos = [
    "all-capone"
  ]
  route53_hostedzone = "Z30OS86JINAD69"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "github_actions_assume_role_cap_one" {

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

resource "aws_iam_role" "github_actions_cap_one" {
  name               = "github-actions-cap-one-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role_cap_one.json
}

# resource "null_resource" "aws_identity_mapping" {
#   depends_on = [
#     aws_iam_role.github_actions_cap_one
#   ]
# 
#   # modifying the aws-auth with k8s provider is risk as it would override the aws-auth https://stackoverflow.com/questions/71408540/create-an-identity-mapping-for-eks-with-terraform
#   provisioner "local-exec" {
#     command = <<-EOT
#       OUT=$(aws sts assume-role --role-arn ${var.eks_cluster_role} --role-session-name terraform-local-exec)
#       export AWS_ACCESS_KEY_ID=$(echo $OUT | jq -r '.Credentials''.AccessKeyId')
#       export AWS_SECRET_ACCESS_KEY=$(echo $OUT | jq -r '.Credentials''.SecretAccessKey')
#       export AWS_SESSION_TOKEN=$(echo $OUT | jq -r '.Credentials''.SessionToken')
#       # eksctl delete iamidentitymapping --cluster ${var.eks_name} --region=${data.aws_region.current.name} --arn ${aws_iam_role.github_actions_cap_one.arn}
#       eksctl create iamidentitymapping --cluster ${var.eks_name} --region=${data.aws_region.current.name} --arn ${aws_iam_role.github_actions_cap_one.arn} --username ${var.eks_deploy_username} --no-duplicate-arns --timeout 2m
#     EOT
#   }
# }

data "aws_iam_policy_document" "github_actions_cap_one" {
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
      "arn:aws:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster/capterra-production-eks",
      "arn:aws:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:addon/capterra-production-eks/*/*",
      "arn:aws:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:fargateprofile/capterra-production-eks/*/*",
      "arn:aws:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:nodegroup/capterra-production-eks/*/*",
    "arn:aws:eks:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:identityproviderconfig/capterra-production-eks/*/*/*"]
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
    resources = ["arn:aws:kms:us-east-1:176540105868:key/5c8ab0dc-f8f5-4760-8b42-7c83fc005f48"]
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

resource "aws_iam_policy" "github_actions_cap_one" {
  name        = "github-actions-cap-one-${var.environment}"
  description = "Grant Github Actions defined scope of AWS actions"
  policy      = data.aws_iam_policy_document.github_actions_cap_one.json
}

resource "aws_iam_role_policy_attachment" "github_actions_cap_one" {
  role       = aws_iam_role.github_actions_cap_one.name
  policy_arn = aws_iam_policy.github_actions_cap_one.arn
}
