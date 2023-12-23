##############################################################################
# Terraform resources for creating a Lambda@Edge
# Lambda@Edge nodejs12.x function to redirect requests and url replacement
##############################################################################

data "archive_file" "folder_index_redirect_zip" {
  type        = "zip"
  output_path = "${path.module}/cap-fn-cf-default.js.zip"
  source_file = "${path.module}/cap-fn-cf-default.js"
}

resource "aws_iam_role_policy" "lambda_execution" {
provider = "aws.primary_cf_account"
  name_prefix = "tf-${var.name}-cloudfront-lambda-policy"
  role        = aws_iam_role.lambda_execution.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:CreateLogGroup"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda_execution" {
provider = "aws.primary_cf_account"
  name_prefix        = "tf-${var.name}-cloudfront-lambda-role"
  description        = "Role for Cloudfront-lambdaedge for SPA app- ${var.name}. Managed by Terraform."
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "edgelambda.amazonaws.com",
          "lambda.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
     terraform_managed = "true"
   }
}

resource "aws_lambda_permission" "alp" {
provider = "aws.primary_cf_account"
   action        = "lambda:InvokeFunction"
   function_name = "${aws_lambda_function.folder_index_redirect.arn}"
   principal     = "events.amazonaws.com"
   statement_id  = "AllowExecution"
 }

resource "aws_lambda_function" "folder_index_redirect" {
provider = "aws.primary_cf_account"
  description      = "lambda function for ${var.name} for rendering default object when multiple dir, basically url changes. Managed by Terraform."
  filename         = "${path.module}/cap-fn-cf-default.js.zip"
  function_name    = "tf-${var.name}-cloudfrontmultidir"
  handler          = "cap-fn-cf-default.handler"
  source_code_hash = data.archive_file.folder_index_redirect_zip.output_base64sha256
  publish          = true
  role             = aws_iam_role.lambda_execution.arn
  runtime          = "nodejs12.x"

  tags = {
         terraform_managed = "true"      
     }
}

resource "aws_cloudwatch_log_group" "tf-cfLogGroup" {
 provider = "aws.primary_cf_account"
   name = "/aws/lambda/tf-${var.name}-cloudfrontmultidir"

   tags = {
     terraform_managed = "true"
     Service = "Cloudfront"
   }
 }

 resource "aws_cloudwatch_log_stream" "acls-cf" {
 provider = "aws.primary_cf_account"
   name           = "cf-logstream"
   log_group_name = "${aws_cloudwatch_log_group.tf-cfLogGroup.name}"
 }