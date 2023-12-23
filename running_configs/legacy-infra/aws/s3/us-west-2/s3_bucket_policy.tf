resource "aws_s3_bucket_policy" "capterra-rep" {
  bucket = "capterra-rep"

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
      "Resource": "arn:aws:s3:::capterra-rep/*",
      "Sid": "Stmt1424708701385"
    }
  ],
  "Version": "2008-10-17"
}
POLICY
}
