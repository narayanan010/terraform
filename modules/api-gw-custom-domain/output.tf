output "account_alias" {
  value = "${data.aws_iam_account_alias.current.account_alias}"
  description = "This is the name of account alias"
}

output "aws_acm_certificate_arn" {
	value = "${aws_acm_certificate.cert.arn}"
	description = "The Amazon Resource Name (ARN) of the ACM Certificate created"
}

output "apigw_dn_id" {
    value = "${aws_api_gateway_domain_name.apgdn.id}"
    description = "The ID of API GW Domain just created"
}

output "apigw_dn_arn" {
    value = "${aws_api_gateway_domain_name.apgdn.arn}"
    description = "The ARN of API GW domain just created"
}