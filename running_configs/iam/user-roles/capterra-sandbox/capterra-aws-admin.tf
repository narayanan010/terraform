###########################################Group and Policies in AWS Admin account for capterra-sandbox AWS Account##################################

#This is for Group and Policy against the Admin Role - capterra-sandbox Account
resource "aws_iam_group" "capterra_sandbox_admin" {
  provider = aws.capterra-aws-admin
  name     = "tf-capterra-grp-assume-capterra-sandbox-admin"
  path     = "/"
}

resource "aws_iam_policy" "capterra_sandbox_admin" {
  provider    = aws.capterra-aws-admin
  name        = "tf-capterra-pol-assume-capterra-sandbox-admin"
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

resource "aws_iam_group_policy_attachment" "capterra_sandbox_admin" {
  provider   = aws.capterra-aws-admin
  group      = aws_iam_group.capterra_sandbox_admin.name
  policy_arn = aws_iam_policy.capterra_sandbox_admin.arn
}




#This is for Group and Policy against the Developer Role - capterra-sandbox Account
resource "aws_iam_group" "capterra_sandbox_developer" {
  provider = aws.capterra-aws-admin
  name     = "tf-capterra-grp-assume-capterra-sandbox-developer"
  path     = "/"
}

resource "aws_iam_policy" "capterra_sandbox_developer" {
  provider    = aws.capterra-aws-admin
  name        = "tf-capterra-pol-assume-capterra-sandbox-developer"
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

resource "aws_iam_group_policy_attachment" "capterra_sandbox_developer" {
  provider   = aws.capterra-aws-admin
  group      = aws_iam_group.capterra_sandbox_developer.name
  policy_arn = aws_iam_policy.capterra_sandbox_developer.arn
}



#This is for Group and Policy against the ReadOnly Role - capterra-sandbox Account
resource "aws_iam_group" "capterra_sandbox_readonly" {
  provider = aws.capterra-aws-admin
  name     = "tf-capterra-grp-assume-capterra-sandbox-readonly"
  path     = "/"
}

resource "aws_iam_policy" "capterra_sandbox_readonly" {
  provider    = aws.capterra-aws-admin
  name        = "tf-capterra-pol-assume-capterra-sandbox-readonly"
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

resource "aws_iam_group_policy_attachment" "capterra_sandbox_readonly" {
  provider   = aws.capterra-aws-admin
  group      = aws_iam_group.capterra_sandbox_readonly.name
  policy_arn = aws_iam_policy.capterra_sandbox_readonly.arn
}



#This is for Group and Policy against the deployer Role - capterra-sandbox Account
resource "aws_iam_group" "capterra_sandbox_deployer" {
  provider = aws.capterra-aws-admin
  name     = "tf-capterra-grp-assume-capterra-sandbox-deployer"
  path     = "/"
}

resource "aws_iam_policy" "capterra_sandbox_deployer" {
  provider    = aws.capterra-aws-admin
  name        = "tf-capterra-pol-assume-capterra-sandbox-deployer"
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

resource "aws_iam_group_policy_attachment" "capterra_sandbox_deployer" {
  provider   = aws.capterra-aws-admin
  group      = aws_iam_group.capterra_sandbox_deployer.name
  policy_arn = aws_iam_policy.capterra_sandbox_deployer.arn
}
