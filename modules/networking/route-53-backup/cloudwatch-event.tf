resource "aws_lambda_permission" "cw-timed-exec" {
  statement_id = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_route53.function_name
  principal     = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.timed-exec.arn
}

resource "aws_cloudwatch_event_rule" "timed-exec" {
  name = "route53-every-${var.interval}-minutes"
  description = "Fires every ${var.interval} minutes and take route53-backup"
  schedule_expression = "rate(${var.interval} minutes)"
}

resource "aws_cloudwatch_event_target" "timed-exec" {
  rule = aws_cloudwatch_event_rule.timed-exec.name
  target_id = aws_lambda_function.lambda_route53.id
  arn = aws_lambda_function.lambda_route53.arn
}
