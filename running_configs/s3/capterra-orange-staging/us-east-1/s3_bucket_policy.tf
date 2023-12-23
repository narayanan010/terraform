#Custom Policy
resource "aws_s3_bucket_policy" "capterra-blog-cdn" {
  bucket = aws_s3_bucket.capterra-blog-cdn.id

  policy = <<POLICY
{
  "Id": "Policy1585659509193",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1585659502029",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
                "${aws_s3_bucket.capterra-blog-cdn.arn}",
                "${aws_s3_bucket.capterra-blog-cdn.arn}/*"
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
resource "aws_s3_bucket_policy" "capterra-terraform-state-314485990717" {
  bucket = aws_s3_bucket.capterra-terraform-state-314485990717.id

  policy = <<POLICY
{
  "Id": "Policy1585659509193",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1585659502029",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
                "${aws_s3_bucket.capterra-terraform-state-314485990717.arn}",
                "${aws_s3_bucket.capterra-terraform-state-314485990717.arn}/*"
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
