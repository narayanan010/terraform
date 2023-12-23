resource "aws_s3_bucket_policy" "blog-ssi-poc" {
  bucket = aws_s3_bucket.blog-ssi-poc.id

  policy = <<POLICY
{
  "Id": "Policy1585634377133",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1585634368404",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
                "${aws_s3_bucket.blog-ssi-poc.arn}",
                "${aws_s3_bucket.blog-ssi-poc.arn}/*"
            ],
      "Principal": {
        "AWS": ${jsonencode(var.principal_list)}
      }
    }
  ]
}
POLICY
}


resource "aws_s3_bucket_policy" "bootstrap-cloudtrail-rarchivelogsbucket-14i19sdm6ca8z" {
  bucket = aws_s3_bucket.bootstrap-cloudtrail-rarchivelogsbucket-14i19sdm6ca8z.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:*",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      },
      "Effect": "Deny",
      "Principal": "*",
      "Resource": "${aws_s3_bucket.bootstrap-cloudtrail-rarchivelogsbucket-14i19sdm6ca8z.arn}/*",
      "Sid": "Enforce HTTPS Connections"
    },
    {
      "Action": "s3:Delete*",
      "Effect": "Deny",
      "Principal": "*",
      "Resource": "${aws_s3_bucket.bootstrap-cloudtrail-rarchivelogsbucket-14i19sdm6ca8z.arn}/*",
      "Sid": "Restrict Delete* Actions"
    },
    {
      "Action": "s3:PutObject",
      "Condition": {
        "StringNotEquals": {
          "s3:x-amz-server-side-encryption": "AES256"
        }
      },
      "Effect": "Deny",
      "Principal": "*",
      "Resource": "${aws_s3_bucket.bootstrap-cloudtrail-rarchivelogsbucket-14i19sdm6ca8z.arn}/*",
      "Sid": "DenyUnEncryptedObjectUploads"
    }
  ],
  "Version": "2008-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "capterra-search-staging-cloudtrail-273213456764" {
  bucket = aws_s3_bucket.capterra-search-staging-cloudtrail-273213456764.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:GetBucketAcl",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Resource": "${aws_s3_bucket.capterra-search-staging-cloudtrail-273213456764.arn}",
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
      "Resource": "${aws_s3_bucket.capterra-search-staging-cloudtrail-273213456764.arn}/*",
      "Sid": "AWSCloudTrailWrite20150319"
    },
    {
      "Action": "s3:*",
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      },
      "Effect": "Deny",
      "Principal": "*",
      "Resource": "${aws_s3_bucket.capterra-search-staging-cloudtrail-273213456764.arn}/*",
      "Sid": "Enforce HTTPS Connections"
    },
    {
      "Action": "s3:Delete*",
      "Effect": "Deny",
      "Principal": "*",
      "Resource": "${aws_s3_bucket.capterra-search-staging-cloudtrail-273213456764.arn}/*",
      "Sid": "Restrict Delete* Actions"
    },
    {
      "Action": "s3:PutObject",
      "Condition": {
        "StringNotEquals": {
          "s3:x-amz-server-side-encryption": "AES256"
        }
      },
      "Effect": "Deny",
      "Principal": "*",
      "Resource": "${aws_s3_bucket.capterra-search-staging-cloudtrail-273213456764.arn}/*",
      "Sid": "DenyUnEncryptedObjectUploads"
    }
  ],
  "Version": "2008-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "capterra-search-staging-config-service-273213456764" {
  bucket = aws_s3_bucket.capterra-search-staging-config-service-273213456764.id

  policy = <<POLICY
{
  "Id": "PutObjPolicy",
  "Statement": [
    {
      "Action": "s3:PutObject",
      "Condition": {
        "StringNotEquals": {
          "s3:x-amz-server-side-encryption": "AES256"
        }
      },
      "Effect": "Deny",
      "Principal": "*",
      "Resource": "${aws_s3_bucket.capterra-search-staging-config-service-273213456764.arn}/*",
      "Sid": "DenyUnEncryptedObjectUploads"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "capterra-search-staging-devops-us-east-1" {
  bucket = aws_s3_bucket.capterra-search-staging-devops-us-east-1.id

  policy = <<POLICY
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "Enforce HTTPS Connections",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": "${aws_s3_bucket.capterra-search-staging-devops-us-east-1.arn}/*\"",
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_s3_bucket_policy" "capterra-search-stg" {
  bucket = aws_s3_bucket.capterra-search-stg.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Resource": "${aws_s3_bucket.capterra-search-stg.arn}/*"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "capterra-terraform-state-273213456764" {
  bucket = aws_s3_bucket.capterra-terraform-state-273213456764.id

  policy = <<POLICY
{
  "Id": "Policy1585634377133",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1585634368404",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
                "${aws_s3_bucket.capterra-terraform-state-273213456764.arn}",
                "${aws_s3_bucket.capterra-terraform-state-273213456764.arn}/*"
            ],
      "Principal": {
        "AWS": ${jsonencode(var.principal_list)}
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_policy" "capterra-user-workspace-staging" {
  bucket = aws_s3_bucket.capterra-user-workspace-staging.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Resource": "${aws_s3_bucket.capterra-user-workspace-staging.arn}/*"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "cwlogs-273213456764" {
  bucket = aws_s3_bucket.cwlogs-273213456764.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:GetBucketAcl",
      "Effect": "Allow",
      "Principal": {
        "Service": "logs.us-east-1.amazonaws.com"
      },
      "Resource": "${aws_s3_bucket.cwlogs-273213456764.arn}",
      "Sid": ""
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
        "Service": "logs.us-east-1.amazonaws.com"
      },
      "Resource": "${aws_s3_bucket.cwlogs-273213456764.arn}/*",
      "Sid": ""
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "directory-page-ui-stg" {
  bucket = aws_s3_bucket.directory-page-ui-stg.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Resource": "${aws_s3_bucket.directory-page-ui-stg.arn}/*"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "gc1-273213456764-netskope-s3" {
  bucket = aws_s3_bucket.gc1-273213456764-netskope-s3.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:GetBucketAcl",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Resource": "${aws_s3_bucket.gc1-273213456764-netskope-s3.arn}",
      "Sid": "AWSCloudTrailAclCheck20150319"
    },
    {
      "Action": "s3:PutObject",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Resource": "${aws_s3_bucket.gc1-273213456764-netskope-s3.arn}/*",
      "Sid": "AWSCloudTrailWrite20150319"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "global-nav-mf-stg" {
  bucket = aws_s3_bucket.global-nav-mf-stg.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Resource": "${aws_s3_bucket.global-nav-mf-stg.arn}/*"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "spotlight-ui-stg" {
  bucket = aws_s3_bucket.spotlight-ui-stg.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowCloudFrontServicePrincipal",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudfront.amazonaws.com"
      },
      "Action": "s3:GetObject",
      "Resource": "${aws_s3_bucket.spotlight-ui-stg.arn}/*",
      "Condition": {
          "StringEquals": {
              "AWS:SourceArn": "arn:aws:cloudfront::273213456764:distribution/E341K2Q9VIV0XW"
          }
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_policy" "vendor-page-ui-stg" {
  bucket = aws_s3_bucket.vendor-page-ui-stg.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Resource": "${aws_s3_bucket.vendor-page-ui-stg.arn}/*"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "vp-ppl-qa" {
  bucket = aws_s3_bucket.vp-ppl-qa.id

  policy = <<POLICY
{
  "Id": "Policy1584989896464",
  "Statement": [
    {
      "Action": [
        "s3:DeleteObject",
        "s3:DeleteObjectVersion",
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:ListBucket",
        "s3:ListBucketVersions",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::273213456764:role/assume-capterra-search-staging-deployer",
          "arn:aws:iam::273213456764:role/assume-capterra-search-staging-developer"
        ]
      },
      "Resource": [
        "${aws_s3_bucket.vp-ppl-qa.arn}",
        "${aws_s3_bucket.vp-ppl-qa.arn}/*"
      ]
    },
    {
     "Action": "s3:GetObject",
     "Effect": "Allow",
     "Principal": {
       "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E13FI6ITPE8VBH"
     },
     "Resource": "${aws_s3_bucket.vp-ppl-qa.arn}/*",
     "Sid": "AllowcloudfronttoS3Access"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "capterra-search-staging-RBR-frodo-team-us-east-1" {
  bucket = aws_s3_bucket.capterra-search-staging-RBR-frodo-team-us-east-1.id

  policy = <<POLICY
{
  "Id": "Policy1584989896464",
  "Statement": [
    {
      "Action": [
        "s3:DeleteObject",
        "s3:DeleteObjectVersion",
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:ListBucket",
        "s3:ListBucketVersions",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::273213456764:role/assume-capterra-search-staging-deployer",
          "arn:aws:iam::273213456764:role/assume-capterra-search-staging-developer"
        ]
      },
      "Resource": [
        "${aws_s3_bucket.capterra-search-staging-RBR-frodo-team-us-east-1.arn}",
        "${aws_s3_bucket.capterra-search-staging-RBR-frodo-team-us-east-1.arn}/*"
      ]
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}
