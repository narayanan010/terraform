###########################################Group and Policies in AWS Admin account for capterra-orange-staging AWS Account##################################

#This is for Group and Policy against the Admin Role - capterra-orange-staging Account
resource "aws_iam_group" "capterra_orange_staging_admin" {
  provider = aws.capterra-aws-admin
  name     = "tf-capterra-grp-assume-capterra-orange-staging-admin"
  path     = "/"
}

resource "aws_iam_policy" "capterra_orange_staging_admin" {
  provider    = aws.capterra-aws-admin
  name        = "tf-capterra-pol-assume-capterra-orange-staging-admin"
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
      "Resource": "${aws_iam_role.admin.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "capterra_orange_staging_admin" {
  provider   = aws.capterra-aws-admin
  group      = aws_iam_group.capterra_orange_staging_admin.name
  policy_arn = aws_iam_policy.capterra_orange_staging_admin.arn
}




#This is for Group and Policy against the Developer Role - capterra-orange-staging Account
resource "aws_iam_group" "capterra_orange_staging_developer" {
  provider = aws.capterra-aws-admin
  name     = "tf-capterra-grp-assume-capterra-orange-staging-developer"
  path     = "/"
}

resource "aws_iam_policy" "capterra_orange_staging_developer" {
  provider    = aws.capterra-aws-admin
  name        = "tf-capterra-pol-assume-capterra-orange-staging-developer"
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
      "Resource": "${aws_iam_role.developer.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "capterra_orange_staging_developer" {
  provider   = aws.capterra-aws-admin
  group      = aws_iam_group.capterra_orange_staging_developer.name
  policy_arn = aws_iam_policy.capterra_orange_staging_developer.arn
}



#This is for Group and Policy against the ReadOnly Role - capterra-orange-staging Account
resource "aws_iam_group" "capterra_orange_staging_readonly" {
  provider = aws.capterra-aws-admin
  name     = "tf-capterra-grp-assume-capterra-orange-staging-readonly"
  path     = "/"
}

resource "aws_iam_policy" "capterra_orange_staging_readonly" {
  provider    = aws.capterra-aws-admin
  name        = "tf-capterra-pol-assume-capterra-orange-staging-readonly"
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
      "Resource": "${aws_iam_role.readonly.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "capterra_orange_staging_readonly" {
  provider   = aws.capterra-aws-admin
  group      = aws_iam_group.capterra_orange_staging_readonly.name
  policy_arn = aws_iam_policy.capterra_orange_staging_readonly.arn
}



#This is for Group and Policy against the deployer Role - capterra-orange-staging Account
resource "aws_iam_group" "capterra_orange_staging_deployer" {
  provider = aws.capterra-aws-admin
  name     = "tf-capterra-grp-assume-capterra-orange-staging-deployer"
  path     = "/"
}

resource "aws_iam_policy" "capterra_orange_staging_deployer" {
  provider    = aws.capterra-aws-admin
  name        = "tf-capterra-pol-assume-capterra-orange-staging-deployer"
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
      "Resource": "${aws_iam_role.deployer.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "capterra_orange_staging_deployer" {
  provider   = aws.capterra-aws-admin
  group      = aws_iam_group.capterra_orange_staging_deployer.name
  policy_arn = aws_iam_policy.capterra_orange_staging_deployer.arn
}
