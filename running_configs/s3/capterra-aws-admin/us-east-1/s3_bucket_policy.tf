resource "aws_s3_bucket_policy" "capterra-cloudtrail-logs" {
  bucket = aws_s3_bucket.capterra-cloudtrail-logs.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:GetBucketAcl",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Resource": "${aws_s3_bucket.capterra-cloudtrail-logs.arn}",
      "Sid": "AWSCloudTrailAclCheck20150319"
    },
    {
      "Action": "s3:PutObject",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      },
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Resource": [
        "${aws_s3_bucket.capterra-cloudtrail-logs.arn}/AWSLogs/237884149494/*",
        "${aws_s3_bucket.capterra-cloudtrail-logs.arn}/AWSLogs/377773991577/*",
        "${aws_s3_bucket.capterra-cloudtrail-logs.arn}/AWSLogs/350125959894/*",
        "${aws_s3_bucket.capterra-cloudtrail-logs.arn}/AWSLogs/738909422062/*",
        "${aws_s3_bucket.capterra-cloudtrail-logs.arn}/AWSLogs/176540105868/*",
        "${aws_s3_bucket.capterra-cloudtrail-logs.arn}/AWSLogs/148797279579/*",
        "${aws_s3_bucket.capterra-cloudtrail-logs.arn}/AWSLogs/296947561675/*",
        "${aws_s3_bucket.capterra-cloudtrail-logs.arn}/AWSLogs/273213456764/*",
        "${aws_s3_bucket.capterra-cloudtrail-logs.arn}/AWSLogs/314485990717/*",
        "${aws_s3_bucket.capterra-cloudtrail-logs.arn}/AWSLogs/944864126557/*"
      ],
      "Sid": "AWSCloudTrailWrite20150319"
    },
    {
      "Sid": "Stmt1585387610192",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
                "${aws_s3_bucket.capterra-cloudtrail-logs.arn}",
                "${aws_s3_bucket.capterra-cloudtrail-logs.arn}/*"
            ],
      "Principal": {
        "AWS": ${jsonencode(var.principal_list)}
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "config-bucket-237884149494" {
  bucket = aws_s3_bucket.config-bucket-237884149494.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:GetBucketAcl",
      "Effect": "Allow",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Resource": "${aws_s3_bucket.config-bucket-237884149494.arn}",
      "Sid": "AWSConfigBucketPermissionsCheck"
    },
    {
      "Action": "s3:PutObject",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      },
      "Effect": "Allow",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Resource": "${aws_s3_bucket.config-bucket-237884149494.arn}/AWSLogs/237884149494/Config/*",
      "Sid": "AWSConfigBucketDelivery"
    },
    {
      "Sid": "Stmt1585387610192",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
                "${aws_s3_bucket.config-bucket-237884149494.arn}",
                "${aws_s3_bucket.config-bucket-237884149494.arn}/*"
            ],
      "Principal": {
        "AWS": ${jsonencode(var.principal_list)}
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "cptra-terraform-state" {
  bucket = aws_s3_bucket.cptra-terraform-state.id

  policy = <<POLICY
{
  "Id": "Policy1571414925002",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::237884149494:role/Capterra-Admin"
      },
      "Resource": [
        "${aws_s3_bucket.cptra-terraform-state.arn}",
        "${aws_s3_bucket.cptra-terraform-state.arn}/*"
      ],
      "Sid": "AdminAccess"
    },
    {
      "Sid": "Stmt1585387610192",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
                "${aws_s3_bucket.cptra-terraform-state.arn}",
                "${aws_s3_bucket.cptra-terraform-state.arn}/*"
            ],
      "Principal": {
        "AWS": ${jsonencode(var.principal_list)}
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}



resource "aws_s3_bucket_policy" "capterra-terraform-state" {
  bucket = aws_s3_bucket.capterra-terraform-state.id

  policy = <<POLICY
{
  "Id": "Policy1571414925002",
  "Statement": [
    {
      "Sid": "AdminAccess",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
                "${aws_s3_bucket.capterra-terraform-state.arn}",
                "${aws_s3_bucket.capterra-terraform-state.arn}/*"
            ],
      "Principal": {
        "AWS": ${jsonencode(concat(["arn:aws:iam::237884149494:user/cap-srv-jenkins-deploy"], var.principal_list))}
      }
    },
    {
        "Sid": "LimitedAccess",
        "Effect": "Allow",
         "Principal": {
            "AWS": [
                "arn:aws:iam::237884149494:user/daoliva",
                "arn:aws:iam::237884149494:user/fperrone"
            ]
        },
        "Action": [
            "s3:Get*",
            "s3:Put*"
        ],
        "Resource": [
                "${aws_s3_bucket.capterra-terraform-state.arn}",
                "${aws_s3_bucket.capterra-terraform-state.arn}/*"
        ]
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}
