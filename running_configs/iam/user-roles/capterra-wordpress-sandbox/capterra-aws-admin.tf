######################################Group and Policies in AWS Admin account for capterra-capterra-wordpress-sandbox AWS Account#################################
#Due to recent change in the name of AWS account capterra-wordpress-sandbox to capterra-wordpress-sbox, it requires us to change Group & Policy in admin account to assume correct Role from wordpress-sbox account- Changes made on 05/22. Details at DEVOPS-4430.

#This is for Group and Policy against the Admin Role - capterra-wordpress-sbox Account
resource "aws_iam_group" "capterra_wordpress_sandbox_admin" {
  provider = aws.capterra-aws-admin
  name     = "tf-capterra-grp-assume-capterra-wordpress-sbox-admin"
  path     = "/"
}

resource "aws_iam_policy" "capterra_wordpress_sandbox_admin" {
  provider    = aws.capterra-aws-admin
  name        = "tf-capterra-pol-assume-capterra-wordpress-sbox-admin"
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

resource "aws_iam_group_policy_attachment" "capterra_wordpress_sandbox_admin" {
  provider   = aws.capterra-aws-admin
  group      = aws_iam_group.capterra_wordpress_sandbox_admin.name
  policy_arn = aws_iam_policy.capterra_wordpress_sandbox_admin.arn
}




#This is for Group and Policy against the Developer Role - capterra-wordpress-sbox Account
resource "aws_iam_group" "capterra_wordpress_sandbox_developer" {
  provider = aws.capterra-aws-admin
  name     = "tf-capterra-grp-assume-capterra-wordpress-sbox-developer"
  path     = "/"
}

resource "aws_iam_policy" "capterra_wordpress_sandbox_developer" {
  provider    = aws.capterra-aws-admin
  name        = "tf-capterra-pol-assume-capterra-wordpress-sbox-developer"
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

resource "aws_iam_group_policy_attachment" "capterra_wordpress_sandbox_developer" {
  provider   = aws.capterra-aws-admin
  group      = aws_iam_group.capterra_wordpress_sandbox_developer.name
  policy_arn = aws_iam_policy.capterra_wordpress_sandbox_developer.arn
}



#This is for Group and Policy against the ReadOnly Role - capterra-wordpress-sbox Account
resource "aws_iam_group" "capterra_wordpress_sandbox_readonly" {
  provider = aws.capterra-aws-admin
  name     = "tf-capterra-grp-assume-capterra-wordpress-sbox-readonly"
  path     = "/"
}

resource "aws_iam_policy" "capterra_wordpress_sandbox_readonly" {
  provider    = aws.capterra-aws-admin
  name        = "tf-capterra-pol-assume-capterra-wordpress-sbox-readonly"
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

resource "aws_iam_group_policy_attachment" "capterra_wordpress_sandbox_readonly" {
  provider   = aws.capterra-aws-admin
  group      = aws_iam_group.capterra_wordpress_sandbox_readonly.name
  policy_arn = aws_iam_policy.capterra_wordpress_sandbox_readonly.arn
}



#This is for Group and Policy against the deployer Role - capterra-wordpress-sbox Account
resource "aws_iam_group" "capterra_wordpress_sandbox_deployer" {
  provider = aws.capterra-aws-admin
  name     = "tf-capterra-grp-assume-capterra-wordpress-sbox-deployer"
  path     = "/"
}

resource "aws_iam_policy" "capterra_wordpress_sandbox_deployer" {
  provider    = aws.capterra-aws-admin
  name        = "tf-capterra-pol-assume-capterra-wordpress-sbox-deployer"
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

resource "aws_iam_group_policy_attachment" "capterra_wordpress_sandbox_deployer" {
  provider   = aws.capterra-aws-admin
  group      = aws_iam_group.capterra_wordpress_sandbox_deployer.name
  policy_arn = aws_iam_policy.capterra_wordpress_sandbox_deployer.arn
}
