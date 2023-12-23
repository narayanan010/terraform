data "aws_iam_policy_document" "assume_role_admin_account" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::237884149494:root"]
    }

    condition {
      test     = "Bool"
      values   = ["true"]
      variable = "aws:MultiFactorAuthPresent"
    }
  }
}


resource "aws_iam_role" "admin_mfa" {
  name                = "assume-${data.aws_iam_account_alias.current.account_alias}-admin-mfa"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_admin_account.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}


resource "aws_iam_role" "readonly_mfa" {
  name                = "assume-${data.aws_iam_account_alias.current.account_alias}-readonly-mfa"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_admin_account.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
}


resource "aws_iam_role" "developer_mfa" {
  name                = "assume-${data.aws_iam_account_alias.current.account_alias}-developer-mfa"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_admin_account.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess", aws_iam_policy.developer-iam.arn, aws_iam_policy.developer-intl-api.arn]
}


resource "aws_iam_policy" "developer-iam" {
  name        = "capterra-developer-iam"
  path        = "/"
  description = "This is custom developer policy created by Terraform"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "iam:UpdateRoleDescription",
                "iam:UpdateRole",
                "iam:UpdateAssumeRolePolicy",
                "iam:PutRolePolicy",
                "iam:PutRolePermissionsBoundary",
                "iam:PassRole",
                "iam:GetRolePolicy",
                "iam:GetRole",
                "iam:GetPolicyVersion",
                "iam:GetPolicy",
                "iam:DetachRolePolicy",
                "iam:DeleteRolePolicy",
                "iam:DeleteRole",
                "iam:DeletePolicyVersion",
                "iam:DeletePolicy",
                "iam:CreateRole",
                "iam:CreatePolicyVersion",
                "iam:CreatePolicy",
                "iam:AttachRolePolicy"
            ],
            "Resource": [
                "arn:aws:iam::296947561675:role/capterra-*search-*",
                "arn:aws:iam::296947561675:policy/capterra-*search-*"
            ]
        }
    ]
}
EOF
}


resource "aws_iam_policy" "developer-intl-api" {
  name        = "es-intl-api-developer"
  path        = "/"
  description = "This is custom developer policy created by Terraform"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "es:ESHttpHead",
                "es:ESHttpPost",
                "es:ESHttpGet",
                "es:DescribeElasticsearchDomains",
                "es:ESHttpDelete",
                "es:ESHttpPut"
            ],
            "Resource": "arn:aws:es:us-east-1:296947561675:domain/capterra-intl-api-prd-001"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "es:ListDomainNames",
            "Resource": "*"
        }
    ]
}
EOF
}


resource "aws_iam_role" "deployer_mfa" {
  name                = "assume-${data.aws_iam_account_alias.current.account_alias}-deployer-mfa"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_admin_account.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/PowerUserAccess", aws_iam_policy.deployer-iam.arn]
}


resource "aws_iam_policy" "deployer-iam" {
  name        = "capterra-deployer-iam"
  path        = "/"
  description = "This is custom developer policy created by Terraform"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "iam:UpdateAssumeRolePolicy",
                "iam:GetRole",
                "iam:GetPolicyVersion",
                "iam:UntagRole",
                "iam:GetPolicy",
                "iam:TagRole",
                "iam:PutRolePermissionsBoundary",
                "iam:UpdateRoleDescription",
                "iam:DeletePolicy",
                "iam:DeleteRole",
                "iam:CreateRole",
                "iam:AttachRolePolicy",
                "iam:PutRolePolicy",
                "iam:CreatePolicy",
                "iam:PassRole",
                "iam:DetachRolePolicy",
                "iam:DeleteRolePolicy",
                "iam:UpdateRole",
                "iam:CreatePolicyVersion",
                "iam:GetRolePolicy",
                "iam:DeletePolicyVersion"
            ],
            "Resource": [
                "arn:aws:iam::296947561675:role/capterra-*search-*",
                "arn:aws:iam::296947561675:role/capterra-vendor-*",
                "arn:aws:iam::296947561675:role/capterra-spotlight*",
                "arn:aws:iam::296947561675:role/capterra-public*",
                "arn:aws:iam::296947561675:role/vp-public-api-service-prd-us-east-1-lambdaRole",
                "arn:aws:iam::296947561675:role/capterra-directory-page-ui-service-prod-us-east-1-lambdaRole",
                "arn:aws:iam::296947561675:role/user-workspace*",
                "arn:aws:iam::296947561675:role/capterra-global-nav-mf-prod-us-east-1-lambdaRole",
                "arn:aws:iam::296947561675:policy/capterra-*search-*",
                "arn:aws:iam::296947561675:policy/capterra-spotlight*",
                "arn:aws:iam::296947561675:policy/capterra-public*",
                "arn:aws:iam::296947561675:policy/capterra-vendor*",
                "arn:aws:iam::296947561675:policy/vp*"
            ]
        }
    ]
}
EOF
}
