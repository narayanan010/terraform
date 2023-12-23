resource "aws_s3_bucket" "vp-ppl-qa" {
     bucket = "vp-ppl-qa"
     acl = "public-read"
     region = "us-east-1"

     website {
         index_document = "index.html"
         error_document = "error.html"
     }

    server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_policy" "vp-ppl-qa-pol" {
  bucket = "${aws_s3_bucket.vp-ppl-qa.id}"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "Policy1584989896464",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::273213456764:role/assume-capterra-search-staging-developer",
                    "arn:aws:iam::273213456764:role/assume-capterra-search-staging-deployer"
                ]
            },
            "Action": [
                "s3:DeleteObject",
                "s3:DeleteObjectVersion",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:ListBucket",
                "s3:ListBucketVersions",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::vp-ppl-qa",
                "arn:aws:s3:::vp-ppl-qa/*"
            ]
        }
    ]
}
POLICY

}