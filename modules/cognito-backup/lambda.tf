# Lambda
resource "aws_lambda_function" "backup_executor_lambda" {
  filename      = data.archive_file.cognito_backup_executor_lambda_code.output_path
  function_name = "${var.vertical}-${var.environment}-cognito-backup-executor-lambda"
  role          = aws_iam_role.backup_executor_lambda.arn
  handler       = "function.handler"

  source_code_hash = data.archive_file.cognito_backup_executor_lambda_code.output_base64sha256

  runtime = "python3.10"
  memory_size = 512
  timeout = 900

  environment {
    variables = {
      BUCKET = aws_s3_bucket.backup_storage.id,
      LENGTH_USERS_LIMIT = 100000
    }
  }
}

# Lambda
resource "aws_lambda_function" "backup_selector_lambda" {
  filename      = data.archive_file.cognito_backup_selector_lambda_code.output_path
  function_name = "${var.vertical}-${var.environment}-cognito-backup-selector-lambda"
  role          = aws_iam_role.backup_selector_lambda.arn
  handler       = "function.handler"

  source_code_hash = data.archive_file.cognito_backup_selector_lambda_code.output_base64sha256

  runtime = "python3.10"
  memory_size = 128
  timeout = 15
}
