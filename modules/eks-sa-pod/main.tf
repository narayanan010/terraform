data "aws_caller_identity" "current" {
  provider = aws.awscaller_account
}

data "aws_iam_policy_document" "assume_role_with_oidc" {
  provider = aws.awscaller_account
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"

      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${var.provider_url}"
      ]
    }
    condition {
              test     = "StringEquals"
              variable = "${var.provider_url}:sub"
              values   = ["system:serviceaccount:${var.namespace}:${var.project_name}-sa"]
          }
  }
}

terraform {
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = ">= 4.55.0"
        configuration_aliases = [ aws.awscaller_account ]
      }
  }
}

resource "aws_iam_role" "this" {
  provider             = aws.awscaller_account
  name                 = "${var.project_name}-${var.env}-access-eks-pod-role"
  max_session_duration = var.max_session_duration
  assume_role_policy   = join("", data.aws_iam_policy_document.assume_role_with_oidc.*.json)

  dynamic inline_policy {
    for_each = var.inline_policy != "" ? [1] : []
    content {
      name   = "inline-policy"
      policy = var.inline_policy
    }
  }
}

