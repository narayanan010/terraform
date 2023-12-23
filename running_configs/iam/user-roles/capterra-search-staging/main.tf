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
  managed_policy_arns = ["arn:aws:iam::aws:policy/PowerUserAccess", aws_iam_policy.developer-iam.arn]
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
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "iam:GetRole",
                "iam:GetPolicyVersion",
                "iam:UntagRole",
                "iam:GetPolicy",
                "iam:TagRole",
                "iam:PutRolePermissionsBoundary",
                "iam:ListEntitiesForPolicy",
                "iam:UpdateRoleDescription",
                "iam:DeletePolicy",
                "iam:CreateRole",
                "iam:AttachRolePolicy",
                "iam:PutRolePolicy",
                "iam:DeleteRolePermissionsBoundary",
                "iam:CreatePolicy",
                "iam:PassRole",
                "iam:DetachRolePolicy",
                "iam:ListPolicyVersions",
                "iam:DeleteRolePolicy",
                "iam:UpdateRole",
                "iam:CreatePolicyVersion",
                "iam:ListRolePolicies",
                "iam:GetRolePolicy",
                "iam:SetDefaultPolicyVersion"
            ],
            "Resource": [
                "arn:aws:iam::273213456764:role/capterra-search*",
                "arn:aws:iam::273213456764:role/vp*",
                "arn:aws:iam::273213456764:role/capterra-vendor-page-ui-service-staging-us-east-1-lambdaRole",
                "arn:aws:iam::273213456764:role/capterra-directory-page-ui-service-staging-us-east-1-lambdaRole",
                "arn:aws:iam::273213456764:role/vp-public-api-service-stg-us-east-1-lambdaRole",
                "arn:aws:iam::273213456764:role/user-workspace-staging-*",
                "arn:aws:iam::273213456764:policy/capterra-search*",
                "arn:aws:iam::273213456764:policy/vp*",
                "arn:aws:iam::273213456764:policy/staging-capterra-vendor-page-ui-service-lambda",
                "arn:aws:iam::273213456764:policy/staging-capterra-directory-page-ui-service-lambda"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "iam:ListPolicies",
                "iam:ListRoles"
            ],
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
                "arn:aws:iam::273213456764:role/capterra-public*",
                "arn:aws:iam::273213456764:role/capterra-vendor*",
                "arn:aws:iam::273213456764:role/capterra-*search-*",
                "arn:aws:iam::273213456764:role/capterra-spotlight*",
                "arn:aws:iam::273213456764:role/vp*",
                "arn:aws:iam::273213456764:role/capterra-vendor-page-ui-service-staging-us-east-1-lambdaRole",
                "arn:aws:iam::273213456764:role/capterra-directory-page-ui-service-staging-us-east-1-lambdaRole",
                "arn:aws:iam::273213456764:role/user-workspace*",
                "arn:aws:iam::273213456764:policy/capterra-*search-*",
                "arn:aws:iam::273213456764:policy/capterra-spotlight-*",
                "arn:aws:iam::273213456764:policy/vp*",
                "arn:aws:iam::273213456764:policy/staging-capterra-vendor-page-ui-service-lambda",
                "arn:aws:iam::273213456764:policy/staging-capterra-directory-page-ui-service-lambda"
            ]
        }
    ]
}
EOF
}
