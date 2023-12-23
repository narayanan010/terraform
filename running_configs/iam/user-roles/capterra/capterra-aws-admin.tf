###########################################Group and Policies in AWS Admin account for Capterra AWS Account###############################################

#This is for Group and Policy against the Admin Role - Capterra Account
resource "aws_iam_group" "capterra_admin_mfa" {
  provider = aws.capterra-aws-admin
  name     = "tf-capterra-grp-assume-capterra-admin-mfa"
  path     = "/"
}
resource "aws_iam_policy" "capterra_admin_mfa" {
  provider    = aws.capterra-aws-admin
  name        = "tf-capterra-pol-assume-capterra-admin-mfa"
  path        = "/"
  description = "This is custom policy for group to enable user to assume the role specified and is created by Terraform"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "${aws_iam_role.admin_mfa.arn}",
      "Condition": {
        "BoolIfExists": {
          "aws:MultiFactorAuthPresent": "true"
        }
      }
    }
  ]
}
EOF
}
resource "aws_iam_group_policy_attachment" "capterra_admin_mfa" {
  provider   = aws.capterra-aws-admin
  group      = aws_iam_group.capterra_admin_mfa.name
  policy_arn = aws_iam_policy.capterra_admin_mfa.arn
}




#This is for Group and Policy against the Developer Role - Capterra Account
resource "aws_iam_group" "capterra_developer_mfa" {
  provider = aws.capterra-aws-admin
  name     = "tf-capterra-grp-assume-capterra-developer-mfa"
  path     = "/"
}
resource "aws_iam_policy" "capterra_developer_mfa" {
  provider    = aws.capterra-aws-admin
  name        = "tf-capterra-pol-assume-capterra-developer-mfa"
  path        = "/"
  description = "This is custom policy for group to enable user to assume the role specified and is created by Terraform"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "${aws_iam_role.developer_mfa.arn}",
      "Condition": {
        "BoolIfExists": {
          "aws:MultiFactorAuthPresent": "true"
        }
      }
    }
  ]
}
EOF
}
resource "aws_iam_group_policy_attachment" "capterra_developer_mfa" {
  provider   = aws.capterra-aws-admin
  group      = aws_iam_group.capterra_developer_mfa.name
  policy_arn = aws_iam_policy.capterra_developer_mfa.arn
}



#This is for Group and Policy against the ReadOnly Role - Capterra Account
resource "aws_iam_group" "capterra_readonly_mfa" {
  provider = aws.capterra-aws-admin
  name     = "tf-capterra-grp-assume-capterra-readonly-mfa"
  path     = "/"
}
resource "aws_iam_policy" "capterra_readonly_mfa" {
  provider    = aws.capterra-aws-admin
  name        = "tf-capterra-pol-assume-capterra-readonly-mfa"
  path        = "/"
  description = "This is custom policy for group to enable user to assume the role specified and is created by Terraform"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "${aws_iam_role.readonly_mfa.arn}",
      "Condition": {
        "BoolIfExists": {
          "aws:MultiFactorAuthPresent": "true"
        }
      }
    }
  ]
}
EOF
}
resource "aws_iam_group_policy_attachment" "capterra_readonly_mfa" {
  provider   = aws.capterra-aws-admin
  group      = aws_iam_group.capterra_readonly_mfa.name
  policy_arn = aws_iam_policy.capterra_readonly_mfa.arn
}



#This is for Group and Policy against the deployer Role - Capterra Account
resource "aws_iam_group" "capterra_deployer_mfa" {
  provider = aws.capterra-aws-admin
  name     = "tf-capterra-grp-assume-capterra-deployer-mfa"
  path     = "/"
}
resource "aws_iam_policy" "capterra_deployer_mfa" {
  provider    = aws.capterra-aws-admin
  name        = "tf-capterra-pol-assume-capterra-deployer-mfa"
  path        = "/"
  description = "This is custom policy for group to enable user to assume the role specified and is created by Terraform"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "${aws_iam_role.deployer_mfa.arn}",
      "Condition": {
        "BoolIfExists": {
          "aws:MultiFactorAuthPresent": "true"
        }
      }
    }
  ]
}
EOF
}
resource "aws_iam_group_policy_attachment" "capterra_deployer_mfa" {
  provider   = aws.capterra-aws-admin
  group      = aws_iam_group.capterra_deployer_mfa.name
  policy_arn = aws_iam_policy.capterra_deployer_mfa.arn
}
