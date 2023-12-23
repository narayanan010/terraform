#Custom Policy
resource "aws_s3_bucket_policy" "capterra-terraform-state-888548925459" {
  bucket = "capterra-terraform-state-888548925459"

  policy = <<POLICY
{
  "Id": "Policy1585661720010",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1585661718728",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
                "arn:aws:s3:::capterra-terraform-state-888548925459",
                "arn:aws:s3:::capterra-terraform-state-888548925459/*"
            ],
      "Principal": {
        "AWS": [
          "arn:aws:iam::888548925459:role/Capterra-Wordpress-PowerUser",
          "arn:aws:iam::888548925459:role/cross-account-roles/GartnerCodeDeployServiceRole",
          "arn:aws:iam::888548925459:role/Capterra-Wordpress-AppsDev",
          "arn:aws:iam::888548925459:role/Gartner-SuperAdmin",
          "arn:aws:iam::888548925459:role/Gartner-SecAdmin",
          "arn:aws:iam::888548925459:role/Capterra-SysAdmin",
          "arn:aws:iam::888548925459:role/Capterra-StorageAdmin",
          "arn:aws:iam::888548925459:role/Capterra-SecAdmin",
          "arn:aws:iam::888548925459:role/Capterra-NetAdmin",
          "arn:aws:iam::888548925459:role/Capterra-DatabaseAdmin",
          "arn:aws:iam::888548925459:role/Capterra-AutomationAdmin",
          "arn:aws:iam::888548925459:role/Capterra-Admin",
          "arn:aws:iam::888548925459:role/assume-capterra-admin"
        ],
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
POLICY
}


