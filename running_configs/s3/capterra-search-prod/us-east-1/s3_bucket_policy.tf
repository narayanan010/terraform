resource "aws_s3_bucket_policy" "cwlogs-296947561675" {
  bucket = aws_s3_bucket.cwlogs-296947561675.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:GetBucketAcl",
      "Effect": "Allow",
      "Principal": {
        "Service": "logs.us-east-1.amazonaws.com"
      },
      "Resource": "${aws_s3_bucket.cwlogs-296947561675.arn}",
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
      "Resource": "${aws_s3_bucket.cwlogs-296947561675.arn}/*",
      "Sid": ""
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "gc1-296947561675-netskope-s3" {
  bucket = aws_s3_bucket.gc1-296947561675-netskope-s3.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:GetBucketAcl",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Resource": "${aws_s3_bucket.gc1-296947561675-netskope-s3.arn}",
      "Sid": "AWSCloudTrailAclCheck20150319"
    },
    {
      "Action": "s3:PutObject",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Resource": "${aws_s3_bucket.gc1-296947561675-netskope-s3.arn}/*",
      "Sid": "AWSCloudTrailWrite20150319"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "forms-as-a-service-prd" {
  bucket = aws_s3_bucket.forms-as-a-service-prd.id

  policy = <<POLICY
{
  "Id": "Policy4353289896461",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E3RY1PG7GN0JCF"
      },
      "Action": "s3:GetObject",
      "Resource": "${aws_s3_bucket.forms-as-a-service-prd.arn}/*"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E3RY1PG7GN0JCF"
      },
      "Action": "s3:ListBucket",
      "Resource": "${aws_s3_bucket.forms-as-a-service-prd.arn}"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}