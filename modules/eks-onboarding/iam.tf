## DEPLOYER: IAM Role
data "aws_iam_policy_document" "iam_deployer_final" {
  statement {
    sid     = "GithubWorkflows"
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.main.account_id}:oidc-provider/token.actions.githubusercontent.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [for repositories in toset(local.github_repository) : "repo:${repositories}:*"]
    }
  }
}

resource "aws_iam_role" "deployer_user_cluster_role" {
  name               = lower("assume-eks-${var.namespace}-${var.stage}-deployer")
  assume_role_policy = data.aws_iam_policy_document.iam_deployer_final.json
}
