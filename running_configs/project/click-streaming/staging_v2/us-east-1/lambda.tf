data "archive_file" "archive_pxEnforcer" {
  type             = "zip"
  source_dir       = "${path.module}/source/PXEnforcer"
  output_path      = "${path.module}/source/function.zip"
  output_file_mode = "0666"
}

resource "aws_lambda_function" "cloudfront_pxEnforcer" {
  function_name = "pxEnforcer-clicks2"
  publish       = true
  filename      = data.archive_file.archive_pxEnforcer.output_path
  role          = aws_iam_role.lambda_pxEnforcer.arn
  #handler       = "index.js"
  handler          = "index.handler"
  description      = "PermiterX lambda to allow HTTPS requests"
  source_code_hash = data.archive_file.archive_pxEnforcer.output_base64sha256
  runtime          = "nodejs12.x"
  memory_size      = 128
  ephemeral_storage {
    size = 512
  }

  depends_on = [data.archive_file.archive_pxEnforcer]
}

resource "aws_cloudwatch_log_group" "cloudfront_pxEnforcer" {
  name              = "/aws/lambda/${aws_lambda_function.cloudfront_pxEnforcer.function_name}"
  retention_in_days = "14"
}