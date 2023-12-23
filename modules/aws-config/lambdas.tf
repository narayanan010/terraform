#This section is for IAM role specification to have bare minimum roles to run Rules properly
resource "aws_iam_role" "custom-config-rule" {
  name_prefix        = "custom-config-rule-role-"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "events.amazonaws.com",
          "lambda.amazonaws.com",
          "config.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}
resource "aws_iam_role_policy_attachment" "custom-config-rule-s3-read-only" {
  role       = aws_iam_role.custom-config-rule.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
resource "aws_iam_role_policy_attachment" "custom-config-rule-ec2-read-only" {
  role       = aws_iam_role.custom-config-rule.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}
resource "aws_iam_role_policy_attachment" "custom-config-rule-basic-lambda-execution" {
  role       = aws_iam_role.custom-config-rule.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}
resource "aws_iam_role_policy_attachment" "custom-config-rule-config-execution" {
  role       = aws_iam_role.custom-config-rule.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRulesExecutionRole"
}

# This section is for lambda1 that checks- S3-BUCKET-ENCRYPTION
resource "aws_lambda_function" "custom-s3-bucket-encryption-check" {
  filename      = "${path.module}/app/custom-s3-bucket-encryption-check/function.zip"
  function_name = "s3-bucket-encryption-config-check"
  role          = aws_iam_role.custom-config-rule.arn
  handler       = "custom-s3-bucket-encryption-check.lambda_handler"

  source_code_hash = filebase64sha256("${path.module}/app/custom-s3-bucket-encryption-check/function.zip")

  runtime = var.runtime_lambda

  environment {
    variables = {
      var1 = "capterra"
    }
  }
}
resource "aws_lambda_permission" "custom-s3-bucket-encryption-check" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.custom-s3-bucket-encryption-check.arn
  principal     = "config.amazonaws.com"
  statement_id  = "AllowExecutionFromConfig"
}

# This section is for lambda2 that checks- S3-BUCKET-POLICY
resource "aws_lambda_function" "custom-s3-bucket-policy-check" {
  filename      = "${path.module}/app/custom-s3-bucket-policy-check/function.zip"
  function_name = "s3-bucket-policy-config-check"
  role          = aws_iam_role.custom-config-rule.arn
  handler       = "custom-s3-bucket-policy-check.lambda_handler"

  source_code_hash = filebase64sha256("${path.module}/app/custom-s3-bucket-policy-check/function.zip")

  runtime = var.runtime_lambda

  environment {
    variables = {
      var1 = "capterra"
    }
  }
}
resource "aws_lambda_permission" "custom-s3-bucket-policy-check" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.custom-s3-bucket-policy-check.arn
  principal     = "config.amazonaws.com"
  statement_id  = "AllowExecutionFromConfig"
}

# This section is for lambda3 that checks- EBS-VOL-ENCRYPTION
resource "aws_lambda_function" "custom-ebs-encryption-check" {
  filename      = "${path.module}/app/custom-ebs-encryption-check/function.zip"
  function_name = "ebs-encryption-config-check"
  role          = aws_iam_role.custom-config-rule.arn
  handler       = "custom-ebs-encryption-check.lambda_handler"

  source_code_hash = filebase64sha256("${path.module}/app/custom-ebs-encryption-check/function.zip")

  runtime = var.runtime_lambda

  environment {
    variables = {
      var1 = "capterra"
    }
  }
}
resource "aws_lambda_permission" "custom-ebs-encryption-check" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.custom-ebs-encryption-check.arn
  principal     = "config.amazonaws.com"
  statement_id  = "AllowExecutionFromConfig"
}
