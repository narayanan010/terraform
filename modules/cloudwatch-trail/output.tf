output "s3_bucket_name" {
  #value       = "tf-capterra-cloudtrail-logs"
  value = "${aws_s3_bucket.as3b-ct.id}"
  description = "Name of s3 bucket used for AWS cloudtrail logs. Default is capterra-cloudtrail-logs bucket from aws-admin account."
}

output "cw-rule_arn-ec2" {
  value = "${aws_cloudwatch_event_rule.acer-sns-ec2.arn}"
  description = "Name of CW Event Rule for ec2 API calls"
}

output "cw-rule_arn-iam" {
  value = "${aws_cloudwatch_event_rule.acer-sns-iam.arn}"
  description = "Name of CW Event Rule for IAM API calls"
}

output "cw-rule_arn-misc" {
  value = "${aws_cloudwatch_event_rule.acer-sns-misc.arn}"
  description = "Name of CW Event Rule for MISC API calls"
}

output "sns_topic_arn" {
  value = "${aws_sns_topic.ast.arn}"
  description = "ARN of SNS Topic"
}

output "lambda_arn" {
  value = "${aws_lambda_function.alf-slack.arn}"
  description = "ARN of Lambda"
}
