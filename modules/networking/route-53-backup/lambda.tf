resource "aws_iam_policy" "lambda_backup53" {
  name        = "lambda_backup53"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
    "Statement": [
        {
            "Action": [
                "s3:PutObject",
                "s3:PutBucketPolicy",
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.backup_target.bucket}/*",
                "arn:aws:s3:::${aws_s3_bucket.backup_target.bucket}"
            ],
            "Sid": "BackupPolicy01"
        },
        {
            "Action": [
                "route53:ListTagsForResources",
                "route53:ListTagsForResource",
                "route53:ListResourceRecordSets",
                "route53:ListHostedZonesByName",
                "route53:ListHostedZones",
                "route53:ListHealthChecks",
                "route53:GetHostedZone",
                "route53:GetHealthCheck"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "BackupPolicy02"
        }
    ],
    "Version": "2012-10-17"
}
EOF
 depends_on = [aws_s3_bucket.backup_target]
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda_route53"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "lambda_route53" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_backup53.arn
}

data "archive_file" "zip" {
  type        = "zip"
  source_dir  = "${path.module}/app/"
  output_path = "${path.module}/backup_route53.zip"
}

resource "aws_lambda_function" "lambda_route53" {
  function_name = "backup-route53"
  description = "Backs up Route53 regularly to a bucket"
  handler = "backup_route53.handle"
  runtime = "python3.9"
  timeout = "300"
  role = aws_iam_role.iam_for_lambda.arn
  filename = "${path.module}/backup_route53.zip"

  environment{
    variables = {
    BUCKET = aws_s3_bucket.backup_target.bucket
                }
         }
}
