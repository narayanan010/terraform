resource "aws_s3_bucket_policy" "capterra-rep" {
  bucket = aws_s3_bucket.capterra-rep.id

  policy = <<POLICY
{
  "Id": "Policy1424708704693",
  "Statement": [
    {
      "Action": [
        "s3:GetObject",
        "s3:PutObjectAcl",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::176540105868:user/vp-prod"
      },
      "Resource": "${aws_s3_bucket.capterra-rep.arn}/*",
      "Sid": "Stmt1424708701385"
    }
  ],
  "Version": "2008-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "gdm-capterra-db-data-archive-uw2_policy" {
  bucket = aws_s3_bucket.gdm-capterra-db-data-archive-uw2.id
  policy = <<POLICY
    {
        "Version": "2012-10-17",
        "Id": "Policy1588873528808",
        "Statement": [
            {
                "Sid": "Stmt1588873520257",
                "Effect": "Allow",
                "Principal": {
                    "AWS": "arn:aws:iam::176540105868:role/capterra-s3-role"
                },
                "Action": [
                    "s3:DeleteObject",
                    "s3:DeleteObjectVersion",
                    "s3:GetObject",
                    "s3:GetObjectVersion",
                    "s3:PutObject",
                    "s3:ReplicateDelete",
                    "s3:ReplicateObject",
                    "s3:ListBucket"
                ],
                "Resource": [
                    "${aws_s3_bucket.gdm-capterra-db-data-archive-uw2.arn}",
                    "${aws_s3_bucket.gdm-capterra-db-data-archive-uw2.arn}/*"
                ]
            }
        ]
    }
    POLICY
}

resource "aws_s3_bucket_policy" "capterra-loadbalancer-dr-logs" {
  bucket = aws_s3_bucket.capterra-loadbalancer-dr-logs.id

  policy = <<POLICY
{
  "Id": "AllowELBWritePolicy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "s3:PutObject",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::797873946194:root"
      },
      "Resource": "${aws_s3_bucket.capterra-loadbalancer-dr-logs.arn}/*",
      "Sid": "Stmt1429136633762"
    },
    {
      "Sid": "AWSLogDeliveryWrite",
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "${aws_s3_bucket.capterra-loadbalancer-dr-logs.arn}/*",
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
      "Resource": "${aws_s3_bucket.capterra-loadbalancer-dr-logs.arn}"
    }
  ]
}
POLICY
}