
resource "aws_s3_bucket_policy" "s3_stormbreaker_policy" {
  bucket = aws_s3_bucket.s3_stormbreaker.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Id" : "Policy1583170931353",
      "Statement" : [
        {
          "Sid" : "OriginAccessControl",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "cloudfront.amazonaws.com"
          },
          "Action" : "s3:GetObject",
          "Resource" : "arn:aws:s3:::${aws_s3_bucket.s3_stormbreaker.id}/*",
          "Condition" : {
            "StringEquals" : {
              "AWS:SourceArn" : "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${var.cf_origin_access_control}"
            }
          }
        }
      ]
    }
  )
}