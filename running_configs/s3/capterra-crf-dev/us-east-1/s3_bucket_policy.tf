resource "aws_s3_bucket_policy" "config-bucket-377773991577" {
  bucket = aws_s3_bucket.config-bucket-377773991577.id

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "s3:GetBucketAcl",
      "Effect": "Allow",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Resource": "${aws_s3_bucket.config-bucket-377773991577.arn}",
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
      "Resource": "${aws_s3_bucket.config-bucket-377773991577.arn}/AWSLogs/377773991577/Config/*",
      "Sid": "AWSConfigBucketDelivery"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_s3_bucket_policy" "gdm-crf-getapp-dev" {
  bucket = aws_s3_bucket.gdm-crf-getapp-dev.id

  policy = <<POLICY
{
  "Id": "Policy1585551979683",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1585551959780",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
                "${aws_s3_bucket.gdm-crf-getapp-dev.arn}",
                "${aws_s3_bucket.gdm-crf-getapp-dev.arn}/*"
            ],
      "Principal": {
        "AWS": ${jsonencode(var.principal_list)}
      }
    }
  ]
}
POLICY
}
