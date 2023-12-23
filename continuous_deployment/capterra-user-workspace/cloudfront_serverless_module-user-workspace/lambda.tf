data "aws_iam_policy_document" "assume_role_policy_doc_redirect_lambda" {
  statement {
    sid    = "AllowAwsToAssumeRole"
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"

      identifiers = [
        "edgelambda.amazonaws.com",
        "lambda.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "redirect_lambda" {
  provider = aws.primary_cf_account
  name     = "redirect-${replace(replace(lower(var.cert_domain_name), ".capstage.net", ""), ".", "-")}-lambda"

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_doc_redirect_lambda.json
}

resource "aws_iam_role_policy_attachment" "redirect_lambda_basic_execution" {
  provider   = aws.primary_cf_account
  role       = aws_iam_role.redirect_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_permission" "allow_cloudfront" {
  provider      = aws.primary_cf_account
  statement_id  = "AllowExecutionFromCloudFront"
  action        = "lambda:GetFunction"
  function_name = aws_lambda_function.redirect_lambda.function_name
  principal     = "edgelambda.amazonaws.com"
}

resource "aws_lambda_function" "redirect_lambda" {
  provider = aws.primary_cf_account

  filename         = "${path.module}/app/redirect-requests/function.zip"
  function_name    = "redirect-${replace(lower(var.cert_domain_name), ".", "-")}"
  role             = aws_iam_role.redirect_lambda.arn
  handler          = "function.handler"
  source_code_hash = filebase64sha256("${path.module}/app/redirect-requests/function.zip")
  runtime          = "python3.9"
  publish          = true

  depends_on = [
    aws_cloudfront_distribution.s3_distribution
  ]
}
