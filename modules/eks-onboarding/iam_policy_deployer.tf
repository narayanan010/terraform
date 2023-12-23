locals {
  ecr_repository_tag_team = length(var.namespace_mapping) > 0 ? (var.namespace_mapping[0].ecr_repository != null ? var.namespace_mapping[0].ecr_repository : lookup(var.ecr_repository_tag_team, var.namespace, "undefined")) : lookup(var.ecr_repository_tag_team, var.namespace, "undefined")
  github_repository       = length(var.namespace_mapping) > 0 ? (var.namespace_mapping[0].github_repository != null ? local.github_repo_list : lookup(var.github_repositories, var.namespace, ["missing-github-repository"])) : lookup(var.github_repositories, var.namespace, ["missing-github-repository"])
  kms_clusters            = length(var.namespace_mapping) > 0 ? (var.namespace_mapping[0].eks_cluster.kms != null ? var.namespace_mapping[0].eks_cluster.kms : var.kms_clusters[lower(var.stage)]) : var.kms_clusters[lower(var.stage)]
  hostedzone              = length(var.namespace_mapping) > 0 ? (var.namespace_mapping[0].eks_cluster.hostedzone != null ? var.namespace_mapping[0].eks_cluster.hostedzone : var.route53_hostedzone[lower(var.stage)]) : var.route53_hostedzone[lower(var.stage)]
  github_repo_list = flatten([
    for key, value in var.namespace_mapping : [value.github_repository]
  ])
}


## DEPLOYER
resource "aws_iam_role_policy" "policy_ecr_deployer" {
  name = "${var.namespace}-${var.stage}-ecr-permissions"
  role = aws_iam_role.deployer_user_cluster_role.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "ECRpermissions1",
          "Effect" : "Allow",
          "Action" : [
            "ecr:BatchCheckLayerAvailability",
            "ecr:BatchGetImage",
            "ecr:BatchGetRepositoryScanningConfiguration",
            "ecr:CompleteLayerUpload",
            "ecr:DescribeImageReplicationStatus",
            "ecr:DescribeImages",
            "ecr:DescribeImageScanFindings",
            "ecr:DescribeRepositories",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetLifecyclePolicy",
            "ecr:GetLifecyclePolicyPreview",
            "ecr:GetRepositoryPolicy",
            "ecr:InitiateLayerUpload",
            "ecr:ListTagsForResource",
            "ecr:PutImage",
            "ecr:TagResource",
            "ecr:UntagResource",
            "ecr:UploadLayerPart"
          ],
          "Resource" : "*",
          "Condition" : {
            "StringLike" : {
              "aws:ResourceTag/team" : lower(local.ecr_repository_tag_team)
            }
          }
        },
        {
          "Sid" : "ECRpermissions2",
          "Effect" : "Allow",
          "Action" : [
            "ecr:GetRegistryPolicy",
            "ecr:DescribeRegistry",
            "ecr:GetAuthorizationToken",
            "ecr:GetRegistryScanningConfiguration"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "policy_eks_deployer" {
  name = "${var.namespace}-${var.stage}-eks-permissions"
  role = aws_iam_role.deployer_user_cluster_role.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "EKSpermissions1",
          "Effect" : "Allow",
          "Action" : [
            "eks:AccessKubernetesApi",
            "eks:DescribeAddon",
            "eks:DescribeAddonVersions",
            "eks:DescribeCluster",
            "eks:DescribeFargateProfile",
            "eks:DescribeIdentityProviderConfig",
            "eks:DescribeNodegroup",
            "eks:DescribeUpdate",
            "eks:ListAddons",
            "eks:ListClusters",
            "eks:ListFargateProfiles",
            "eks:ListIdentityProviderConfigs",
            "eks:ListNodegroups",
            "eks:ListTagsForResource",
            "eks:ListUpdates",
            "eks:TagResource",
            "eks:UntagResource"
          ],
          "Resource" : [
            "${data.aws_eks_cluster.cluster.arn}/*/*",
            "${data.aws_eks_cluster.cluster.arn}"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "policy_kms_deployer" {
  name = "${var.namespace}-${var.stage}-kms-permissions"
  role = aws_iam_role.deployer_user_cluster_role.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "KMSpermissions1",
          "Effect" : "Allow",
          "Action" : [
            "kms:Decrypt",
            "kms:DescribeKey",
            "kms:Encrypt",
            "kms:GetKeyPolicy",
            "kms:GetKeyRotationStatus",
            "kms:GetParametersForImport",
            "kms:ListAliases",
            "kms:ListGrants",
            "kms:ListKeyPolicies",
            "kms:ListKeys",
            "kms:ListResourceTags",
            "kms:ListRetirableGrants"
          ],
          "Resource" : "arn:aws:kms:${data.aws_region.main.name}:${data.aws_caller_identity.main.account_id}:key/${local.kms_clusters}"
        },
        {
          "Action" : [
            "kms:ListKeys",
            "kms:ListAliases",
            "kms:DescribeCustomKeyStores"
          ],
          "Effect" : "Allow",
          "Resource" : "*",
          "Sid" : "KMSpermissions2"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "policy_route53_deployer" {
  name = "${var.namespace}-${var.stage}-route53-permissions"
  role = aws_iam_role.deployer_user_cluster_role.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "Route53permissions1",
          "Effect" : "Allow",
          "Action" : [
            "route53:ListTagsForResources",
            "route53:ListTagsForResource",
            "route53:ListResourceRecordSets",
            "route53:GetHostedZoneLimit",
            "route53:GetHostedZone",
            "route53:GetHealthCheck",
            "route53:ChangeResourceRecordSets"
          ],
          "Resource" : "arn:aws:route53:::hostedzone/${local.hostedzone}"
        },
        {
          "Action" : [
            "route53:ListHostedZonesByName",
            "route53:ListHostedZones",
            "route53:ListHealthChecks",
            "route53:GetHostedZoneCount"
          ],
          "Effect" : "Allow",
          "Resource" : "*",
          "Sid" : "Route53permissions2"
        }
      ]
    }
  )
}


