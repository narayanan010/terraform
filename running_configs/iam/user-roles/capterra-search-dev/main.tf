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
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess", aws_iam_policy.panorama_s3.arn]
}


resource "aws_iam_policy" "panorama_s3" {
  name        = "panorama-access-s3"
  path        = "/"
  description = "This is custom admin policy to specific s3 created by Terraform to Access capterra-devops bucket in main account for Panorama"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:PutObjectAcl"
            ],
            "Resource": "arn:aws:s3:::arn:aws:s3:::capterra-devops/panorama/*"
        }
    ]
}
EOF
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
                "iam:GetPolicy",
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
                "arn:aws:iam::148797279579:policy/capterra-search*",
                "arn:aws:iam::148797279579:policy/capterra-vendor*",
                "arn:aws:iam::148797279579:policy/vp*",
                "arn:aws:iam::148797279579:role/capterra-search*",
                "arn:aws:iam::148797279579:role/capterra-vendor*",
                "arn:aws:iam::148797279579:role/vp*",
                "arn:aws:iam::148797279579:role/capterra-directory-page-ui-service-dev-us-east-1-lambdaRole",
                "arn:aws:iam::148797279579:policy/dev-capterra-directory-page-ui-service-lambda"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "iam:ListPolicies",
                "iam:GetRole",
                "iam:GetPolicyVersion",
                "iam:GetPolicy",
                "iam:ListPolicyVersions",
                "iam:ListEntitiesForPolicy",
                "iam:ListRoles",
                "iam:ListRolePolicies",
                "iam:GetRolePolicy"
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
  managed_policy_arns = ["arn:aws:iam::aws:policy/PowerUserAccess", aws_iam_policy.deployer-iam-search.arn, aws_iam_policy.dynamodb_rw.arn, aws_iam_policy.deployer-iam-spotlight.arn]
}


resource "aws_iam_policy" "deployer-iam-search" {
  name        = "capterra-deployer-iam-search"
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
                "arn:aws:iam::148797279579:role/capterra-*search-*",
                "arn:aws:iam::148797279579:policy/capterra-*search-*"
            ]
        }
    ]
}
EOF
}


resource "aws_iam_policy" "dynamodb_rw" {
  name        = "dynamodb-rw"
  path        = "/"
  description = "This is custom developer policy created by Terraform for DynamoDB"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:DeleteItem",
                "dynamodb:GetItem",
                "dynamodb:PutItem",
                "dynamodb:Scan",
                "dynamodb:UpdateItem"
            ],
            "Resource": "arn:aws:dynamodb:us-east-1:148797279579:table/*"
        }
    ]
}
EOF
}


resource "aws_iam_policy" "deployer-iam-spotlight" {
  name        = "capterra-deployer-iam-spotlight"
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
                "iam:GetPolicy",
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
                "arn:aws:iam::148797279579:role/capterra-vendor*",
                "arn:aws:iam::148797279579:role/capterra-spotlight*",
                "arn:aws:iam::148797279579:role/capterra-*",
                "arn:aws:iam::148797279579:policy/capterra-spotlight*",
                "arn:aws:iam::148797279579:policy/capterra-public*",
                "arn:aws:iam::148797279579:policy/capterra-vendor*"
            ]
        }
    ]
}
EOF
}
