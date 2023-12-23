resource "aws_s3_bucket" "capterra-cloudtrail-sandbox-s3" {
  bucket = "capterra-cloudtrail-sandbox-s3"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    NAME = "capterra-cloudtrail-sandbox-s3"
  }

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::capterra-cloudtrail-sandbox-s3"
        },
        {
            "Sid": "AWSCloudTrailWrite20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::capterra-cloudtrail-sandbox-s3/AWSLogs/944864126557/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        },
        {
            "Sid": "Stmt1585481521819",
            "Action": "s3:*",
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::capterra-cloudtrail-sandbox-s3",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::944864126557:root",
                    "arn:aws:iam::944864126557:role/no-color-staging-admin",
                    "arn:aws:iam::944864126557:role/Gartner-SuperAdmin",
                    "arn:aws:iam::944864126557:role/Capterra-SysAdmin",
                    "arn:aws:iam::944864126557:role/Capterra-StorageAdmin",
                    "arn:aws:iam::944864126557:role/Capterra-SecAdmin",
                    "arn:aws:iam::944864126557:role/Capterra-NetAdmin",
                    "arn:aws:iam::944864126557:role/Capterra-DatabaseAdmin",
                    "arn:aws:iam::944864126557:role/Capterra-AutomationAdmin",
                    "arn:aws:iam::944864126557:role/Capterra-Admin",
                    "arn:aws:iam::944864126557:role/assume-capterra-sandbox-admin-mfa",
                    "arn:aws:iam::944864126557:role/Capterra-No-Color-Staging-AppsDev",
                    "arn:aws:iam::944864126557:role/service-role/prod-to-stg-dev-replication-s3-role-acoj9i0k",
                    "arn:aws:iam::944864126557:role/cross-account-roles/GartnerCodeDeployServiceRole"
                ]
           }
        }
    ]
}
POLICY
}
