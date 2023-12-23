resource "aws_s3_bucket_policy" "capterra-terraform-state-350125959894" {
  bucket = aws_s3_bucket.capterra-terraform-state-350125959894.id

  policy = <<POLICY
{
  "Id": "Policy1585572525913",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1585572523071",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
                "${aws_s3_bucket.capterra-terraform-state-350125959894.arn}",
                "${aws_s3_bucket.capterra-terraform-state-350125959894.arn}/*"
            ],
      "Principal": {
        "AWS": [
          "arn:aws:iam::350125959894:role/gdm-admin-access",
          "arn:aws:iam::350125959894:role/cross-account-roles/GartnerCodeDeployServiceRole",
          "arn:aws:iam::350125959894:role/service-role/crf-dev-stream-cw-scalyr-role",
          "arn:aws:iam::350125959894:role/Capterra-Admin",
          "arn:aws:iam::350125959894:role/Capterra-AutomationAdmin",
          "arn:aws:iam::350125959894:role/Capterra-CRF-Staging-AppsDev",
          "arn:aws:iam::350125959894:role/Capterra-DatabaseAdmin",
          "arn:aws:iam::350125959894:role/Capterra-NetAdmin",
          "arn:aws:iam::350125959894:role/Capterra-SecAdmin",
          "arn:aws:iam::350125959894:role/Capterra-StorageAdmin",
          "arn:aws:iam::350125959894:role/Capterra-SysAdmin",
          "arn:aws:iam::350125959894:role/Gartner-SecAdmin",
          "arn:aws:iam::350125959894:role/Gartner-SuperAdmin"
        ]
      }
    }
  ]
}
POLICY
}


resource "aws_s3_bucket_policy" "central-review-form-staging" {
  bucket = aws_s3_bucket.central-review-form-staging.id

  policy = <<POLICY
{
  "Id": "Policy1392681112290",
  "Statement": [
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Resource": "${aws_s3_bucket.central-review-form-staging.arn}/*",
      "Sid": "Stmt1392681101677"
    }
  ],
  "Version": "2008-10-17"
}
POLICY
}


resource "aws_s3_bucket_policy" "central-review-form-stg" {
  bucket = aws_s3_bucket.central-review-form-stg.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Resource": "${aws_s3_bucket.central-review-form-stg.arn}/*"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}


resource "aws_s3_bucket_policy" "cf-templates-v9cvpqe2cj7r-us-east-1" {
  bucket = aws_s3_bucket.cf-templates-v9cvpqe2cj7r-us-east-1.id

  policy = <<POLICY
{
  "Id": "Policy1585572525913",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1585572523071",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
                "${aws_s3_bucket.cf-templates-v9cvpqe2cj7r-us-east-1.arn}",
                "${aws_s3_bucket.cf-templates-v9cvpqe2cj7r-us-east-1.arn}/*"
            ],
      "Principal": {
        "AWS": [
          "arn:aws:iam::350125959894:role/gdm-admin-access",
          "arn:aws:iam::350125959894:role/cross-account-roles/GartnerCodeDeployServiceRole",
          "arn:aws:iam::350125959894:role/service-role/crf-dev-stream-cw-scalyr-role",
          "arn:aws:iam::350125959894:role/Capterra-Admin",
          "arn:aws:iam::350125959894:role/Capterra-AutomationAdmin",
          "arn:aws:iam::350125959894:role/Capterra-CRF-Staging-AppsDev",
          "arn:aws:iam::350125959894:role/Capterra-DatabaseAdmin",
          "arn:aws:iam::350125959894:role/Capterra-NetAdmin",
          "arn:aws:iam::350125959894:role/Capterra-SecAdmin",
          "arn:aws:iam::350125959894:role/Capterra-StorageAdmin",
          "arn:aws:iam::350125959894:role/Capterra-SysAdmin",
          "arn:aws:iam::350125959894:role/Gartner-SecAdmin",
          "arn:aws:iam::350125959894:role/Gartner-SuperAdmin"
        ]
      }
    }
  ]
}
POLICY
}
