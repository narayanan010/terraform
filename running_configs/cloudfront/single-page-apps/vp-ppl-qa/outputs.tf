output "aws_cloudfront_distribution_tfer--E2ISACMFVBFD87_id" {
  value = "${aws_cloudfront_distribution.tfer--E2ISACMFVBFD87.id}"
}

output "aws_s3_bucket_policy_tfer--vp-002D-ppl-002D-qa_id" {
  value = "${aws_s3_bucket_policy.tfer--vp-002D-ppl-002D-qa.id}"
}

output "aws_s3_bucket_tfer--vp-002D-ppl-002D-qa_id" {
  value = "${aws_s3_bucket.tfer--vp-002D-ppl-002D-qa.id}"
}

output "cloudfront_OAI_iam_arn" {
    value = "${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"
    description = "The iam_arn of Cloudfront OAI just created for SPA (Single Page App)"
}