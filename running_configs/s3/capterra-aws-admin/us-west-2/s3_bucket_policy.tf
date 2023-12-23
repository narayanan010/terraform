resource "aws_s3_bucket_policy" "capterra-cloudtrail-logs-rep" {
  bucket = aws_s3_bucket.capterra-cloudtrail-logs-rep.id

  policy = <<POLICY
{
  "Id": "S3-Console-Replication-Policy",
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetBucketVersioning",
        "s3:PutBucketVersioning",
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::237884149494:root"
      },
      "Resource": [
        "${aws_s3_bucket.capterra-cloudtrail-logs-rep.arn}",
        "${aws_s3_bucket.capterra-cloudtrail-logs-rep.arn}/*"
      ],
      "Sid": "S3ReplicationPolicyStmt1"
    },
    {
      "Sid": "Stmt1585387610192",
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [
                "${aws_s3_bucket.capterra-cloudtrail-logs-rep.arn}",
                "${aws_s3_bucket.capterra-cloudtrail-logs-rep.arn}/*"
            ],
      "Principal": {
        "AWS": ${jsonencode(var.principal_list)}
      }
    }
  ]  
}
POLICY
}
