# Role for Lambda - Source: Read S3 Objects
resource "aws_iam_role" "external_replicator" {
  name  = "capterra-s3-replicator"
  description  = "Role for Lambda replication"
  assume_role_policy = data.aws_iam_policy_document.external_replicator.json
}

data "aws_iam_policy_document" "external_replicator" {
  statement {
    sid     = ""
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}


resource "aws_iam_role_policy" "inline_pol_lambda_function" {
  name = "BIExportPolicy"
  role = aws_iam_role.external_replicator.name
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Action" : [
            "s3:ListBucket",
            "s3:GetBucketLocation"
          ],
          "Resource" : [
            "${aws_s3_bucket.bi-export.arn}",
            "${aws_s3_bucket.bi-export-rep.arn}",
            #"arn:aws:s3:::capterra-bi-data-export-rep"
          ]
        },
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Action" : [
            "s3:PutObject",
            "s3:PutObjectAcl",
            "s3:GetObject",
            "s3:GetObjectAcl",
            "s3:DeleteObject"
          ],
          "Resource" : [
            "${aws_s3_bucket.bi-export.arn}/*",
            "${aws_s3_bucket.bi-export-rep.arn}/*",
          ]
        },
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Action" : [
            "sts:AssumeRole"
          ],
          "Resource" : ["arn:aws:iam::933445003212:role/dm-prod-cap-s3-crossaccount"]
        },
                {
          "Sid" : "",
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" : ["*"]
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  role = aws_iam_role.external_replicator.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"

  depends_on = [aws_iam_role.external_replicator]
}
