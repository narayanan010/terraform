resource "aws_s3_bucket_policy" "capterra" {
  bucket = "capterra"

  policy = <<POLICY
{
  "Id": "Policy1424708704693",
  "Statement": [
    {
      "Action": [
        "s3:ListBucketByTags",
        "s3:GetLifecycleConfiguration",
        "s3:GetBucketTagging",
        "s3:GetInventoryConfiguration",
        "s3:DeleteObjectVersion",
        "s3:GetObjectVersionTagging",
        "s3:ListBucketVersions",
        "s3:GetBucketLogging",
        "s3:RestoreObject",
        "s3:ListBucket",
        "s3:GetAccelerateConfiguration",
        "s3:GetBucketPolicy",
        "s3:GetObjectVersionTorrent",
        "s3:GetObjectAcl",
        "s3:GetEncryptionConfiguration",
        "s3:GetBucketRequestPayment",
        "s3:GetObjectVersionAcl",
        "s3:GetObjectTagging",
        "s3:GetMetricsConfiguration",
        "s3:DeleteObject",
        "s3:GetIpConfiguration",
        "s3:ListBucketMultipartUploads",
        "s3:GetBucketWebsite",
        "s3:GetBucketVersioning",
        "s3:GetBucketAcl",
        "s3:GetBucketNotification",
        "s3:GetReplicationConfiguration",
        "s3:ListMultipartUploadParts",
        "s3:PutObject",
        "s3:GetObject",
        "s3:GetObjectTorrent",
        "s3:GetBucketCORS",
        "s3:GetAnalyticsConfiguration",
        "s3:GetObjectVersionForReplication",
        "s3:GetBucketLocation",
        "s3:GetObjectVersion"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:role/service-role/capterra-role-us-e-1-cdn-update-metadata"
      },
      "Resource": [
        "arn:aws:s3:::capterra/*",
        "arn:aws:s3:::capterra"
      ],
      "Sid": "lambda-metadata-update"
    },
    {
      "Action": [
        "s3:GetObjectAcl",
        "s3:DeleteObject",
        "s3:GetObject",
        "s3:PutObjectAcl",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:role/assume-capterra-designer"
      },
      "Resource": "arn:aws:s3:::capterra/*",
      "Sid": "cap-role-designer"
    }
  ],
  "Version": "2008-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "capterra-cloudtrail" {
  bucket = "capterra-cloudtrail"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:GetBucketAcl",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Resource": "arn:aws:s3:::capterra-cloudtrail",
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
      "Resource": "arn:aws:s3:::capterra-cloudtrail/cloudtrail-log-/AWSLogs/176540105868/*",
      "Sid": "AWSCloudTrailWrite20150319"
    },
    {
      "Action": "s3:ListBucket",
      "Condition": {
        "StringLike": {
          "s3:prefix": [
            "firehose/*",
            "mining-data/*"
          ]
        }
      },
      "Effect": "Allow",
      "Principal": {
        "Service": "machinelearning.amazonaws.com"
      },
      "Resource": "arn:aws:s3:::capterra-cloudtrail",
      "Sid": "AmazonML_s3:ListBucket"
    },
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Principal": {
        "Service": "machinelearning.amazonaws.com"
      },
      "Resource": [
        "arn:aws:s3:::capterra-cloudtrail/firehose/*",
        "arn:aws:s3:::capterra-cloudtrail/mining-data/*",
        "arn:aws:s3:::capterra-cloudtrail/mining-data/predict_results.csv*"
      ],
      "Sid": "AmazonML_s3:GetObject"
    },
    {
      "Action": "s3:PutObject",
      "Effect": "Allow",
      "Principal": {
        "Service": "machinelearning.amazonaws.com"
      },
      "Resource": "arn:aws:s3:::capterra-cloudtrail/mining-data/predict_results.csv*",
      "Sid": "AmazonML_s3:PutObject"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "capterra-development" {
  bucket = "capterra-development"

  policy = <<POLICY
{
  "Id": "Policy1423857524712",
  "Statement": [
    {
      "Action": [
        "s3:GetObjectAcl",
        "s3:DeleteObject",
        "s3:GetObject",
        "s3:PutObjectAcl",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:user/cap-svc-development"
      },
      "Resource": "arn:aws:s3:::capterra-development/*",
      "Sid": "cap-svc-dev"
    },
    {
      "Action": [
        "s3:GetObjectAcl",
        "s3:DeleteObject",
        "s3:GetObject",
        "s3:PutObjectAcl",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:role/assume-capterra-designer"
      },
      "Resource": "arn:aws:s3:::capterra-development/*",
      "Sid": "cap-role-designer"
    }
  ],
  "Version": "2008-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "capterra-loadbalancer-logs" {
  bucket = "capterra-loadbalancer-logs"

  policy = <<POLICY
{
  "Id": "AllowELBWritePolicy",
  "Statement": [
    {
      "Action": "s3:PutObject",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::127311923021:root"
      },
      "Resource": "arn:aws:s3:::capterra-loadbalancer-logs/*",
      "Sid": "Stmt1429136633762"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "capterra-staging" {
  bucket = "capterra-staging"

  policy = <<POLICY
{
  "Id": "Policy1423857524712",
  "Statement": [
    {
      "Action": [
        "s3:ListBucketByTags",
        "s3:GetLifecycleConfiguration",
        "s3:GetBucketTagging",
        "s3:GetInventoryConfiguration",
        "s3:DeleteObjectVersion",
        "s3:GetObjectVersionTagging",
        "s3:ListBucketVersions",
        "s3:GetBucketLogging",
        "s3:RestoreObject",
        "s3:ListBucket",
        "s3:GetAccelerateConfiguration",
        "s3:GetBucketPolicy",
        "s3:GetObjectVersionTorrent",
        "s3:GetObjectAcl",
        "s3:GetEncryptionConfiguration",
        "s3:GetBucketRequestPayment",
        "s3:GetObjectVersionAcl",
        "s3:GetObjectTagging",
        "s3:GetMetricsConfiguration",
        "s3:DeleteObject",
        "s3:GetIpConfiguration",
        "s3:ListBucketMultipartUploads",
        "s3:GetBucketWebsite",
        "s3:GetBucketVersioning",
        "s3:GetBucketAcl",
        "s3:GetBucketNotification",
        "s3:GetReplicationConfiguration",
        "s3:ListMultipartUploadParts",
        "s3:PutObject",
        "s3:GetObject",
        "s3:GetObjectTorrent",
        "s3:GetBucketCORS",
        "s3:GetAnalyticsConfiguration",
        "s3:GetObjectVersionForReplication",
        "s3:GetBucketLocation",
        "s3:GetObjectVersion"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:role/service-role/capterra-role-us-e-1-cdn-update-metadata"
      },
      "Resource": [
        "arn:aws:s3:::capterra-staging/*",
        "arn:aws:s3:::capterra-staging"
      ],
      "Sid": "lambda-metadata-update"
    },
    {
      "Action": [
        "s3:GetObjectAcl",
        "s3:DeleteObject",
        "s3:GetObject",
        "s3:PutObjectAcl",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:user/cap-svc-staging"
      },
      "Resource": "arn:aws:s3:::capterra-staging/*",
      "Sid": ""
    },
    {
      "Action": [
        "s3:GetObjectAcl",
        "s3:DeleteObject",
        "s3:GetObject",
        "s3:PutObjectAcl",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:role/assume-capterra-designer"
      },
      "Resource": "arn:aws:s3:::capterra-staging/*",
      "Sid": "cap-role-designer"
    }
  ],
  "Version": "2008-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "capui" {
  bucket = "capui"

  policy = <<POLICY
{
  "Id": "Policy1537903270126",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::176540105868:role/assume-capterra-power-user",
          "arn:aws:iam::176540105868:role/assume-capterra-admin"
        ]
      },
      "Resource": "arn:aws:s3:::capui",
      "Sid": "Stmt1537903147739"
    },
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Resource": "arn:aws:s3:::capui/*",
      "Sid": "Stmt1537903259689"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "capui--capstage--net" {
  bucket = "capui.capstage.net"

  policy = <<POLICY
{
  "Id": "Policy1537903270126",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::176540105868:role/assume-capterra-power-user",
          "arn:aws:iam::176540105868:role/assume-capterra-admin"
        ]
      },
      "Resource": "arn:aws:s3:::capui.capstage.net",
      "Sid": "Stmt1537903147739"
    },
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Resource": "arn:aws:s3:::capui.capstage.net/*",
      "Sid": "Stmt1537903259689"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "elasticbeanstalk-us-east-1-176540105868" {
  bucket = "elasticbeanstalk-us-east-1-176540105868"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:PutObject",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:role/aws-elasticbeanstalk-ec2-role"
      },
      "Resource": "arn:aws:s3:::elasticbeanstalk-us-east-1-176540105868/resources/environments/logs/*",
      "Sid": "eb-ad78f54a-f239-4c90-adda-49e5f56cb51e"
    },
    {
      "Action": [
        "s3:ListBucketVersions",
        "s3:GetObjectVersion",
        "s3:ListBucket",
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:role/aws-elasticbeanstalk-ec2-role"
      },
      "Resource": [
        "arn:aws:s3:::elasticbeanstalk-us-east-1-176540105868/resources/environments/*",
        "arn:aws:s3:::elasticbeanstalk-us-east-1-176540105868"
      ],
      "Sid": "eb-af163bf3-d27b-4712-b795-d1e33e331ca4"
    },
    {
      "Action": "s3:DeleteBucket",
      "Effect": "Deny",
      "Principal": {
        "AWS": "*"
      },
      "Resource": "arn:aws:s3:::elasticbeanstalk-us-east-1-176540105868",
      "Sid": "eb-58950a8c-feb6-11e2-89e0-0800277d041b"
    }
  ],
  "Version": "2008-10-17"
}
POLICY
}
