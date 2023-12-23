resource "aws_s3_bucket_policy" "aws-athena-query-results-176540105868-us-east-1" {
  bucket = aws_s3_bucket.aws-athena-query-results-176540105868-us-east-1.id

  policy = <<POLICY
{
  "Id": "Policy1581957521067",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:root"
      },
      "Resource": "${aws_s3_bucket.aws-athena-query-results-176540105868-us-east-1.arn}/*",
      "Sid": "Stmt1581957508947"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}


resource "aws_s3_bucket_policy" "capcon2010" {
  bucket = aws_s3_bucket.capcon2010.id

  policy = <<POLICY
{
  "Id": "Policy1578324428836",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:root"
      },
      "Resource": "${aws_s3_bucket.capcon2010.arn}",
      "Sid": "Stmt1578324423933"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "capterra" {
  bucket = aws_s3_bucket.capterra.id

  policy = <<POLICY
{
  "Id": "Policy1424708704693",
  "Statement": [
    {
      "Action": [
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
        "${aws_s3_bucket.capterra.arn}/*",
        "${aws_s3_bucket.capterra.arn}"
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
      "Resource": "${aws_s3_bucket.capterra.arn}/*",
      "Sid": "cap-role-designer"
    },
    {
      "Action": [
        "s3:GetObjectAcl",
        "s3:DeleteObject",
        "s3:GetObject",
        "s3:PutObjectAcl",
        "s3:PutObject",
        "s3:GetObjectVersion",
        "s3:GetBucketAcl",
        "s3:GetBucketPolicy",
        "s3:GetObjectVersionAcl",
        "s3:PutObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:role/assume-capterra-developer"
      },
      "Resource": [
        "${aws_s3_bucket.capterra.arn}",
        "${aws_s3_bucket.capterra.arn}/assets/images/sem-ui/*"
      ],
      "Sid": "cap-role-developer"
    },
    {
      "Action": [
        "s3:GetObjectAcl",
        "s3:DeleteObject",
        "s3:GetObject",
        "s3:PutObjectAcl",
        "s3:PutObject",
        "s3:ListBucketVersions"
      ],
      "Effect": "Allow",
      "Principal": {
          "AWS": "arn:aws:iam::176540105868:role/assume-capterra-perms-vp"
      },
      "Resource": [
        "arn:aws:s3:::capterra//assets/images/gdm-badges/*",
        "arn:aws:s3:::capterra"
      ],
      "Sid": "cap-role-assume-capterra-perms-vp"
    },
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Principal": {
          "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E328SID23XDDL6"
      },
      "Resource": "arn:aws:s3:::capterra/*",
      "Sid": "cf-oai-capterra-prod"
    },
    {
      "Sid": "EnforceTLSv12orHigher",
      "Principal": {
        "AWS": "*"
      },
      "Action": ["s3:*"],
      "Effect": "Deny",
      "Resource": [
        "arn:aws:s3:::capterra/*",
        "arn:aws:s3:::capterra"
      ],
      "Condition": {
        "NumericLessThan": {
          "s3:TlsVersion": 1.2
        }
      }
    }
  ],
  "Version": "2008-10-17"
}
POLICY
}


resource "aws_s3_bucket_policy" "capterra-backup" {
  bucket = aws_s3_bucket.capterra-backup.id

  policy = <<POLICY
{
  "Id": "Policy-capterra-backup",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:root"
      },
      "Resource": "${aws_s3_bucket.capterra-backup.arn}",
      "Sid": "Stmt-capterra-backup"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "capterra-cloudtrail" {
  bucket = aws_s3_bucket.capterra-cloudtrail.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:GetBucketAcl",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Resource": "${aws_s3_bucket.capterra-cloudtrail.arn}",
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
      "Resource": "${aws_s3_bucket.capterra-cloudtrail.arn}/cloudtrail-log-/AWSLogs/176540105868/*",
      "Sid": "AWSCloudTrailWrite20150319"
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
      "Resource": "${aws_s3_bucket.capterra-cloudtrail.arn}/cloudtrail-log-/AWSLogs/148797279579/*",
      "Sid": "Search-Dev-Account-148797279579"
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
      "Resource": "${aws_s3_bucket.capterra-cloudtrail.arn}",
      "Sid": "AmazonML_s3:ListBucket"
    },
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Principal": {
        "Service": "machinelearning.amazonaws.com"
      },
      "Resource": [
        "${aws_s3_bucket.capterra-cloudtrail.arn}/firehose/*",
        "${aws_s3_bucket.capterra-cloudtrail.arn}/mining-data/*",
        "${aws_s3_bucket.capterra-cloudtrail.arn}/mining-data/predict_results.csv*"
      ],
      "Sid": "AmazonML_s3:GetObject"
    },
    {
      "Action": "s3:PutObject",
      "Effect": "Allow",
      "Principal": {
        "Service": "machinelearning.amazonaws.com"
      },
      "Resource": "${aws_s3_bucket.capterra-cloudtrail.arn}/mining-data/predict_results.csv*",
      "Sid": "AmazonML_s3:PutObject"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "capterra-development" {
  bucket = aws_s3_bucket.capterra-development.id

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
        "AWS": "arn:aws:iam::176540105868:role/assume-capterra-designer"
      },
      "Resource": "${aws_s3_bucket.capterra-development.arn}/*",
      "Sid": "cap-role-designer"
    }
  ],
  "Version": "2008-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "capterra-devops" {
  bucket = aws_s3_bucket.capterra-devops.id

  policy = <<POLICY
{
  "Id": "Policy1572783864842",
  "Statement": [
    {
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:PutObjectAcl"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::148797279579:role/panorama-collector",
          "arn:aws:iam::237884149494:role/panorama-collector",
          "arn:aws:iam::273213456764:role/panorama-collector",
          "arn:aws:iam::296947561675:role/panorama-collector",
          "arn:aws:iam::350125959894:role/panorama-collector",
          "arn:aws:iam::377773991577:role/panorama-collector",
          "arn:aws:iam::738909422062:role/panorama-collector"
        ]
      },
      "Resource": "${aws_s3_bucket.capterra-devops.arn}/panorama/*",
      "Sid": "Stmt1572783853391"
    },
    {
      "Sid": "Allow inspector to perform Put and Delete actions on s3",
      "Effect": "Allow",
      "Principal": {
        "Service": "inspector2.amazonaws.com"
      },
      "Action": [
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:AbortMultipartUpload"
      ],
      "Resource": "arn:aws:s3:::capterra-devops/*",
      "Condition": {
        "StringEquals": {
          "aws:SourceAccount": "176540105868"
        },
        "ArnLike": {
          "aws:SourceArn": "arn:aws:inspector2:us-east-1:176540105868:report/*"
        }
      }
    },
    {
      "Action": [
        "s3:GetObject",
        "s3:GetObjectAcl",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:PutObjectAcl"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::148797279579:role/assume-capterra-search-dev-admin",
          "arn:aws:iam::273213456764:role/assume-capterra-search-staging-admin",
          "arn:aws:iam::296947561675:role/assume-capterra-search-prd-admin",
          "arn:aws:iam::350125959894:role/gdm-admin-access",
          "arn:aws:iam::377773991577:role/crf-dev-admin",
          "arn:aws:iam::738909422062:role/assume-crf-production-admin"
        ]
      },
      "Resource": "${aws_s3_bucket.capterra-devops.arn}/panorama/*",
      "Sid": "Stmt1572783853391"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "capterra-infra-lambdas" {
  bucket = aws_s3_bucket.capterra-infra-lambdas.id

  policy = <<POLICY
{
  "Id": "Policy-capterra-infra-lambdas",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:root"
      },
      "Resource": "${aws_s3_bucket.capterra-infra-lambdas.arn}",
      "Sid": "Stmt-capterra-infra-lambdas"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "capterra-loadbalancer-logs" {
  bucket = aws_s3_bucket.capterra-loadbalancer-logs.id

  policy = <<POLICY
{
  "Id": "AllowELBWritePolicy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "s3:PutObject",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::127311923021:root"
      },
      "Resource": "${aws_s3_bucket.capterra-loadbalancer-logs.arn}/*",
      "Sid": "Stmt1429136633762"
    },
    {
      "Sid": "AWSLogDeliveryWrite",
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "${aws_s3_bucket.capterra-loadbalancer-logs.arn}/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Sid": "AWSLogDeliveryAclCheck",
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "${aws_s3_bucket.capterra-loadbalancer-logs.arn}"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_policy" "capterra-oracle" {
  bucket = aws_s3_bucket.capterra-oracle.id

  policy = <<POLICY
{
  "Id": "Policy-capterra-oracle",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:root"
      },
      "Resource": "${aws_s3_bucket.capterra-oracle.arn}",
      "Sid": "Stmt-capterra-oracle"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "capterra-staging" {
  bucket = aws_s3_bucket.capterra-staging.id

  policy = <<POLICY
{
  "Id": "Policy1423857524712",
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": [
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
        "${aws_s3_bucket.capterra-staging.arn}/*",
        "${aws_s3_bucket.capterra-staging.arn}"
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
      "Resource": "${aws_s3_bucket.capterra-staging.arn}/*",
      "Sid": "cap-role-designer"
    },
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E3QCCCIKNZXJDH"
      },
      "Resource": "arn:aws:s3:::capterra-staging/*",
      "Sid": "cf-oai-capterra-staging"
    },
    {
      "Sid": "EnforceTLSv12orHigher",
      "Principal": {
        "AWS": "*"
      },
      "Action": ["s3:*"],
      "Effect": "Deny",
      "Resource": [
        "arn:aws:s3:::capterra-staging/*",
        "arn:aws:s3:::capterra-staging"
      ],
      "Condition": {
        "NumericLessThan": {
          "s3:TlsVersion": 1.2
        }
      }
    }
  ]
}
POLICY
}


resource "aws_s3_bucket_policy" "capui" {
  bucket = aws_s3_bucket.capui.id

  policy = <<POLICY
{
  "Id": "Policy1537903270126",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::176540105868:role/assume-capterra-admin",
          "arn:aws:iam::176540105868:role/assume-capterra-power-user"
        ]
      },
      "Resource": "${aws_s3_bucket.capui.arn}",
      "Sid": "Stmt1537903147739"
    },
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Resource": "${aws_s3_bucket.capui.arn}/*",
      "Sid": "Stmt1537903259689"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "capui_capstage_net" {
  bucket = aws_s3_bucket.capui_capstage_net.id

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
          "arn:aws:iam::176540105868:role/cap-role-jenkins-ec2-instance-profile",
          "arn:aws:iam::176540105868:role/assume-capterra-admin"
        ]
      },
      "Resource": "${aws_s3_bucket.capui_capstage_net.arn}",
      "Sid": "Stmt1537903147739"
    },
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E3QCCCIKNZXJDH"
      },
      "Resource": "${aws_s3_bucket.capui_capstage_net.arn}/*",
      "Sid": "Stmt1537903259689"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}


resource "aws_s3_bucket_policy" "equinix-storagegateway-nonprod" {
  bucket = aws_s3_bucket.equinix-storagegateway-nonprod.id

  policy = <<POLICY
{
  "Id": "Policy1576600316813",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:root"
      },
      "Resource": "${aws_s3_bucket.equinix-storagegateway-nonprod.arn}",
      "Sid": "S3AllowAll"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}


#Custom Policy
resource "aws_s3_bucket_policy" "gdm-capterra-db-backup" {
  bucket = aws_s3_bucket.gdm-capterra-db-backup.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowAlltoCapterraS3Role",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:role/capterra-s3-role"
      },
      "Action": [
        "s3:Put*",
        "s3:Get*",
        "s3:DeleteObject",
        "s3:ListBucketMultipartUploads",
        "s3:AbortMultipartUpload",
        "s3:ListMultipartUploadParts"
      ],
      "Resource": [
        "${aws_s3_bucket.gdm-capterra-db-backup.arn}",
        "${aws_s3_bucket.gdm-capterra-db-backup.arn}/*"
      ]
    },
    {
      "Sid": "AllowtoLambda",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:role/equinix-storagegateway-prod_s3_to_gdm-capterra-db-backup"
      },
      "Action": [
        "s3:Put*",
        "s3:Get*",
        "s3:DeleteObject",
        "s3:ListBucketMultipartUploads",
        "s3:AbortMultipartUpload",
        "s3:ListMultipartUploadParts"
      ],
      "Resource": [
        "${aws_s3_bucket.gdm-capterra-db-backup.arn}",
        "${aws_s3_bucket.gdm-capterra-db-backup.arn}/*"
      ]
    }
  ]
}
POLICY
}


resource "aws_s3_bucket_policy" "gdm-capterra-db-data-archive" {
  bucket = aws_s3_bucket.gdm-capterra-db-data-archive.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:role/assume-capterra-admin"
      },
      "Resource": [
        "${aws_s3_bucket.gdm-capterra-db-data-archive.arn}",
        "${aws_s3_bucket.gdm-capterra-db-data-archive.arn}/*"
      ],
      "Sid": "capterra_admin"
    },
    {
      "Action": [
        "s3:DeleteObject",
        "s3:DeleteObjectVersion",
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:ListBucketVersions",
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:PutObjectRetention",
        "s3:PutObjectVersionAcl",
        "s3:ReplicateDelete",
        "s3:ReplicateObject"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:role/capterra-s3-role"
      },
      "Resource": [
        "${aws_s3_bucket.gdm-capterra-db-data-archive.arn}",
        "${aws_s3_bucket.gdm-capterra-db-data-archive.arn}/*"
      ],
      "Sid": "Stmt1588873763941"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}


resource "aws_s3_bucket_policy" "softwaremarketingconference_com" {
  bucket = aws_s3_bucket.softwaremarketingconference_com.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Resource": "${aws_s3_bucket.softwaremarketingconference_com.arn}/*",
      "Sid": "PublicReadGetObject"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "vp-reviews-reports-staging" {
  bucket = aws_s3_bucket.vp-reviews-reports-staging.id

  policy = <<POLICY
{
  "Id": "Policy-vp-reviews-reports-staging",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:root"
      },
      "Resource": "${aws_s3_bucket.vp-reviews-reports-staging.arn}",
      "Sid": "Stmt-vp-reviews-reports-staging"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "vp-reviews-reports-prod" {
  bucket = aws_s3_bucket.vp-reviews-reports-prod.id

  policy = <<POLICY
{
  "Id": "Policy-vp-reviews-reports-prod",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:root"
      },
      "Resource": "${aws_s3_bucket.vp-reviews-reports-prod.arn}",
      "Sid": "Stmt-vp-reviews-reports-prod"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}


resource "aws_s3_bucket_policy" "vp-clicks-reports-staging" {
  bucket = aws_s3_bucket.vp-clicks-reports-staging.id

  policy = <<POLICY
{
  "Id": "Policy-vp-clicks-reports-staging",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:root"
      },
      "Resource": "${aws_s3_bucket.vp-clicks-reports-staging.arn}",
      "Sid": "Stmt-vp-clicks-reports-staging"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "vp-clicks-reports-prod" {
  bucket = aws_s3_bucket.vp-clicks-reports-prod.id

  policy = <<POLICY
{
  "Id": "Policy-vp-clicks-reports-prod",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:root"
      },
      "Resource": "${aws_s3_bucket.vp-clicks-reports-prod.arn}",
      "Sid": "Stmt-vp-clicks-reports-prod"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "vp-frontend-production" {
  bucket = aws_s3_bucket.vp-frontend-production.id

  policy = <<POLICY
{
  "Id": "Policy-vp-frontend-production",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:root"
      },
      "Resource": "${aws_s3_bucket.vp-frontend-production.arn}",
      "Sid": "Stmt-vp-frontend-production"
    },
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Principal": {
          "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity EOEILKUH11FQD"
      },
      "Resource": "${aws_s3_bucket.vp-frontend-production.arn}/*",
      "Sid": "cf-oai-vp-frontend-prod"
    }    
  ],
  "Version": "2012-10-17"
}
POLICY
}

######################################
###Bidding policy
######################################

resource "aws_s3_bucket_policy" "ppc-rankins-exports-prod" {
  bucket = aws_s3_bucket.ppc-rankins-exports-prod.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": [
            "arn:aws:iam::237884149494:user/bidding-prod-ecs",
            "arn:aws:iam::237884149494:user/bidding-staging-ecs"
          ]
      },
      "Resource": "${aws_s3_bucket.ppc-rankins-exports-prod.arn}/*"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "ppc-rankins-exports-staging" {
  bucket = aws_s3_bucket.ppc-rankins-exports-staging.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": [
            "arn:aws:iam::237884149494:user/bidding-staging-ecs"
          ]
      },
      "Resource": "${aws_s3_bucket.ppc-rankins-exports-staging.arn}/*"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "uvp-pendo-data" {
  bucket = aws_s3_bucket.uvp-pendo-data.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Principal": {
        "AWS": [
            "arn:aws:iam::176540105868:user/uvp-pendo-stage"
          ]
      },
      "Resource": [
            "${aws_s3_bucket.uvp-pendo-data.arn}",
            "${aws_s3_bucket.uvp-pendo-data.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": [
            "arn:aws:iam::176540105868:user/uvp-pendo-stage"
          ]
      },
      "Resource": "${aws_s3_bucket.uvp-pendo-data.arn}/*"
    },
    {
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": [
            "arn:aws:iam::933445003212:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_Gartner-DM-DataPlatformProd_6e88eb93515cbf27"
          ]
      },
      "Resource": [
            "${aws_s3_bucket.uvp-pendo-data.arn}",
            "${aws_s3_bucket.uvp-pendo-data.arn}/*"
      ]
    }

  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "autobidder-stage" {
  bucket = aws_s3_bucket.autobidder-stage.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetObject"
      ],
      "Principal": {
        "AWS": [
            "arn:aws:iam::933445003212:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_Gartner-DM-DataScientist_4071e94432ea95d5",
            "arn:aws:iam::933445003212:role/dm-datascience-prefect-agent-serviceaccount-role-prod"
          ]
      },
      "Resource": [
            "${aws_s3_bucket.autobidder-stage.arn}",
            "${aws_s3_bucket.autobidder-stage.arn}/*"
      ]
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "autobidder-prod" {
  bucket = aws_s3_bucket.autobidder-prod.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetObject"
      ],
      "Principal": {
        "AWS": [
            "arn:aws:iam::933445003212:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_Gartner-DM-DataScientist_4071e94432ea95d5",
            "arn:aws:iam::933445003212:role/dm-datascience-prefect-agent-serviceaccount-role-prod"
          ]
      },
      "Resource": [
            "${aws_s3_bucket.autobidder-prod.arn}",
            "${aws_s3_bucket.autobidder-prod.arn}/*"
      ]
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "vp-exports-staging" {
  bucket = aws_s3_bucket.vp-exports-staging.id

  policy = <<POLICY
{
  "Id": "Policy-vp-exports-staging",
  "Statement": [
    {
      "Action":[
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:root"
      },
      "Resource": "arn:aws:s3:::${aws_s3_bucket.vp-exports-staging.id}/*",
      "Sid": "Stmt-vp-exports-staging"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}


resource "aws_s3_bucket_policy" "vp-exports-prod" {
  bucket = aws_s3_bucket.vp-exports-prod.id

  policy = <<POLICY
{
  "Id": "Policy-vp-exports-prod",
  "Statement": [
    {
      "Action": [
	 "s3:GetObject",
         "s3:PutObject"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:root"      
      },
      "Resource": "arn:aws:s3:::${aws_s3_bucket.vp-exports-prod.id}/*",
      "Sid": "Stmt-vp-exports-prod"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}


resource "aws_s3_bucket_policy" "shortlist" {
  bucket = aws_s3_bucket.shortlist.id

  policy = <<POLICY
{
  "Id": "Policy-shortlist",
  "Statement": [
    {
      "Action": [
         "s3:GetObject",
         "s3:PutObject"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:root"
      },
      "Resource": "arn:aws:s3:::${aws_s3_bucket.shortlist.id}/*",
      "Sid": "Stmt-shortlist"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

