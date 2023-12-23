output "apigw_dn_id" {
	value = "${module.apigw_cd.apigw_dn_id}"
	description = "The ID of Cloudfront distribution just created for Serverless App"	
}

output "aws_acm_certificate_arn" {
	value = "${module.apigw_cd.aws_acm_certificate_arn}"
	description = "The Amazon Resource Name (ARN) of the ACM Certificate created for Serverless App"
}

output "apigw_dn_arn" {
	value = "${module.apigw_cd.apigw_dn_arn}"
	description = "The iam_arn of Cloudfront OAI just created for Serverless App"
}