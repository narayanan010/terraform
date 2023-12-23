resource "aws_s3_bucket_policy" "ai-reviews" {
  bucket = aws_s3_bucket.ai-reviews.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Resource": "${aws_s3_bucket.ai-reviews.arn}/*",
      "Sid": "AddPerm"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}


#Custom Policy
resource "aws_s3_bucket_policy" "alexathon" {
  bucket = aws_s3_bucket.alexathon.id

  policy = <<POLICY
{
  "Id": "Policy1585640759904",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1585640757673",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
                "${aws_s3_bucket.alexathon.arn}",
                "${aws_s3_bucket.alexathon.arn}/*"
            ],
      "Principal": {
        "AWS": ${jsonencode(var.principal_list)},
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
POLICY
}


resource "aws_s3_bucket_policy" "bootstrap-cloudtrail-rarchivelogsbucket-hpa2s5vwi4l" {
  bucket = aws_s3_bucket.bootstrap-cloudtrail-rarchivelogsbucket-hpa2s5vwi4l.id

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
      "Resource": "${aws_s3_bucket.bootstrap-cloudtrail-rarchivelogsbucket-hpa2s5vwi4l.arn}/*",
      "Sid": "Enforce HTTPS Connections"
    },
    {
      "Action": "s3:Delete*",
      "Effect": "Deny",
      "Principal": "*",
      "Resource": "${aws_s3_bucket.bootstrap-cloudtrail-rarchivelogsbucket-hpa2s5vwi4l.arn}/*",
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
      "Resource": "${aws_s3_bucket.bootstrap-cloudtrail-rarchivelogsbucket-hpa2s5vwi4l.arn}/*",
      "Sid": "DenyUnEncryptedObjectUploads"
    }
  ],
  "Version": "2008-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "capterra-devops_com" {
  bucket = aws_s3_bucket.capterra-devops_com.id

  policy = <<POLICY
{
  "Id": "RootBucket_Policy",
  "Statement": [
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Resource": "${aws_s3_bucket.capterra-devops_com.arn}/*"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}


#Custom Policy
resource "aws_s3_bucket_policy" "capterra-panorama" {
  bucket = aws_s3_bucket.capterra-panorama.id

  policy = <<POLICY
{
  "Id": "Policy1585640759904",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1585640757673",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
                "${aws_s3_bucket.capterra-panorama.arn}",
                "${aws_s3_bucket.capterra-panorama.arn}/*"
            ],
      "Principal": {
        "AWS": ${jsonencode(var.principal_list)},
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_policy" "capterra-search-dev" {
  bucket = aws_s3_bucket.capterra-search-dev.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Resource": "${aws_s3_bucket.capterra-search-dev.arn}/*"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "capterra-search-dev-cloudtrail-148797279579" {
  bucket = aws_s3_bucket.capterra-search-dev-cloudtrail-148797279579.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:GetBucketAcl",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Resource": "${aws_s3_bucket.capterra-search-dev-cloudtrail-148797279579.arn}",
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
      "Resource": "${aws_s3_bucket.capterra-search-dev-cloudtrail-148797279579.arn}/*",
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
      "Resource": "${aws_s3_bucket.capterra-search-dev-cloudtrail-148797279579.arn}/*",
      "Sid": "Enforce HTTPS Connections"
    },
    {
      "Action": "s3:Delete*",
      "Effect": "Deny",
      "Principal": "*",
      "Resource": "${aws_s3_bucket.capterra-search-dev-cloudtrail-148797279579.arn}/*",
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
      "Resource": "${aws_s3_bucket.capterra-search-dev-cloudtrail-148797279579.arn}/*",
      "Sid": "DenyUnEncryptedObjectUploads"
    }
  ],
  "Version": "2008-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "capterra-search-dev-config-service-148797279579" {
  bucket = aws_s3_bucket.capterra-search-dev-config-service-148797279579.id

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
      "Resource": "${aws_s3_bucket.capterra-search-dev-config-service-148797279579.arn}/*",
      "Sid": "DenyUnEncryptedObjectUploads"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "capterra-search-dev-devops-us-east-1" {
  bucket = aws_s3_bucket.capterra-search-dev-devops-us-east-1.id

  policy = <<POLICY
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "Enforce HTTPS Connections",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": "${aws_s3_bucket.capterra-search-dev-devops-us-east-1.arn}/*\"",
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


#Custom Policy
resource "aws_s3_bucket_policy" "capterra-search-dev-error-page" {
  bucket = aws_s3_bucket.capterra-search-dev-error-page.id

  policy = <<POLICY
{
  "Id": "Policy1585640759904",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1585640757673",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
                "${aws_s3_bucket.capterra-search-dev-error-page.arn}",
                "${aws_s3_bucket.capterra-search-dev-error-page.arn}/*"
            ],
      "Principal": {
        "AWS": ${jsonencode(var.principal_list)},
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
POLICY
}



#Custom Policy
resource "aws_s3_bucket_policy" "capterra-search-dev-redirect-bucket" {
  bucket = aws_s3_bucket.capterra-search-dev-redirect-bucket.id

  policy = <<POLICY
{
  "Id": "Policy1585640759904",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1585640757673",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
                "${aws_s3_bucket.capterra-search-dev-redirect-bucket.arn}",
                "${aws_s3_bucket.capterra-search-dev-redirect-bucket.arn}/*"
            ],
      "Principal": {
        "AWS": ${jsonencode(var.principal_list)},
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
POLICY
}


#Custom Policy
resource "aws_s3_bucket_policy" "capterra-terraform-state-148797279579" {
  bucket = aws_s3_bucket.capterra-terraform-state-148797279579.id

  policy = <<POLICY
{
  "Id": "Policy1585640759904",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1585640757673",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
                "${aws_s3_bucket.capterra-terraform-state-148797279579.arn}",
                "${aws_s3_bucket.capterra-terraform-state-148797279579.arn}/*"
            ],
      "Principal": {
        "AWS": ${jsonencode(var.principal_list)},
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_policy" "central-review-form-dev1" {
  bucket = aws_s3_bucket.central-review-form-dev1.id

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
      "Resource": "${aws_s3_bucket.central-review-form-dev1.arn}/*",
      "Sid": "Stmt1392681101677"
    }
  ],
  "Version": "2008-10-17"
}
POLICY
}


#Custom Policy
resource "aws_s3_bucket_policy" "cf-templates-wmoif3kd83uh-us-east-1" {
  bucket = aws_s3_bucket.cf-templates-wmoif3kd83uh-us-east-1.id

  policy = <<POLICY
{
  "Id": "Policy1585640759904",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1585640757673",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
                "${aws_s3_bucket.cf-templates-wmoif3kd83uh-us-east-1.arn}",
                "${aws_s3_bucket.cf-templates-wmoif3kd83uh-us-east-1.arn}/*"
            ],
      "Principal": {
        "AWS": ${jsonencode(var.principal_list)},
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_policy" "cwlogs-148797279579" {
  bucket = aws_s3_bucket.cwlogs-148797279579.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:GetBucketAcl",
      "Effect": "Allow",
      "Principal": {
        "Service": "logs.us-east-1.amazonaws.com"
      },
      "Resource": "${aws_s3_bucket.cwlogs-148797279579.arn}",
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
      "Resource": "${aws_s3_bucket.cwlogs-148797279579.arn}/*",
      "Sid": ""
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}


#Custom Policy
resource "aws_s3_bucket_policy" "dev-cap-eloqua-ftp" {
  bucket = aws_s3_bucket.dev-cap-eloqua-ftp.id

  policy = <<POLICY
{
  "Id": "Policy1585640759904",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1585640757673",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
                "${aws_s3_bucket.dev-cap-eloqua-ftp.arn}",
                "${aws_s3_bucket.dev-cap-eloqua-ftp.arn}/*"
            ],
      "Principal": {
        "AWS": ${jsonencode(var.principal_list)},
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_policy" "directory-page-ui-dev" {
  bucket = aws_s3_bucket.directory-page-ui-dev.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Resource": "${aws_s3_bucket.directory-page-ui-dev.arn}/*"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "gc1-148797279579-netskope-s3" {
  bucket = aws_s3_bucket.gc1-148797279579-netskope-s3.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:GetBucketAcl",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Resource": "${aws_s3_bucket.gc1-148797279579-netskope-s3.arn}",
      "Sid": "AWSCloudTrailAclCheck20150319"
    },
    {
      "Action": "s3:PutObject",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Resource": "${aws_s3_bucket.gc1-148797279579-netskope-s3.arn}/*",
      "Sid": "AWSCloudTrailWrite20150319"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}


#Custom Policy
resource "aws_s3_bucket_policy" "lex-web-ui-codebuilddeploy-j9ou600p8-webappbucket-v77hkgy3ld15" {
  bucket = aws_s3_bucket.lex-web-ui-codebuilddeploy-j9ou600p8-webappbucket-v77hkgy3ld15.id

  policy = <<POLICY
{
  "Id": "Policy1585640759904",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1585640757673",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
                "${aws_s3_bucket.lex-web-ui-codebuilddeploy-j9ou600p8-webappbucket-v77hkgy3ld15.arn}",
                "${aws_s3_bucket.lex-web-ui-codebuilddeploy-j9ou600p8-webappbucket-v77hkgy3ld15.arn}/*"
            ],
      "Principal": {
        "AWS": ${jsonencode(var.principal_list)},
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_policy" "react-performance-research" {
  bucket = aws_s3_bucket.react-performance-research.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Resource": "${aws_s3_bucket.react-performance-research.arn}/*",
      "Sid": "PublicReadGetObject"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}


#Custom Policy
resource "aws_s3_bucket_policy" "sa-ppl-dev-arlen" {
  bucket = aws_s3_bucket.sa-ppl-dev-arlen.id

  policy = <<POLICY
{
  "Id": "Policy1585640759904",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1585640757673",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
                "${aws_s3_bucket.sa-ppl-dev-arlen.arn}",
                "${aws_s3_bucket.sa-ppl-dev-arlen.arn}/*"
            ],
      "Principal": {
        "AWS": ${jsonencode(var.principal_list)},
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
POLICY
}

resource "aws_s3_bucket_policy" "spotlight-ui-dev" {
  bucket = aws_s3_bucket.spotlight-ui-dev.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Resource": "${aws_s3_bucket.spotlight-ui-dev.arn}/*"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "vendor-page-ui-dev" {
  bucket = aws_s3_bucket.vendor-page-ui-dev.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:GetObject",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Resource": "${aws_s3_bucket.vendor-page-ui-dev.arn}/*"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}


#Custom Policy
resource "aws_s3_bucket_policy" "www_capterra-devops_com" {
  bucket = aws_s3_bucket.www_capterra-devops_com.id

  policy = <<POLICY
{
  "Id": "Policy1585640759904",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1585640757673",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
                "${aws_s3_bucket.www_capterra-devops_com.arn}",
                "${aws_s3_bucket.www_capterra-devops_com.arn}/*"
            ],
      "Principal": {
        "AWS": ${jsonencode(var.principal_list)},
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
POLICY
}
