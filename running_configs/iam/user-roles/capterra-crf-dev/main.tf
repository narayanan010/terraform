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
  managed_policy_arns = [aws_iam_policy.developer.arn]
}


resource "aws_iam_policy" "developer" {
  name        = "capterra-developer"
  path        = "/"
  description = "This is custom developer policy created by Terraform"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "NotAction": [
                "iam:*",
                "organizations:*",
                "cloudtrail:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:CreateServiceLinkedRole",
                "iam:DeleteServiceLinkedRole",
                "iam:ListRoles",
                "organizations:DescribeOrganization",
                "cloudtrail:GetTrailStatus",
                "cloudtrail:DescribeTrails",
                "cloudtrail:LookupEvents",
                "cloudtrail:ListTags",
                "cloudtrail:ListPublicKeys",
                "cloudtrail:GetEventSelectors",
                "s3:ListAllMyBuckets"
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
  managed_policy_arns = ["arn:aws:iam::aws:policy/PowerUserAccess"]
}
