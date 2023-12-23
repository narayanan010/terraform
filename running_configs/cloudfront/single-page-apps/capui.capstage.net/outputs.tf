output "aws_cloudfront_distribution_tfer--E3L9SUS5ZIX971_id" {
  value = "${aws_cloudfront_distribution.tfer--E3L9SUS5ZIX971.id}"
}

output "aws_s3_bucket_policy_tfer--capui-002E-capstage-002E-net_id" {
  value = "${aws_s3_bucket_policy.tfer--capui-002E-capstage-002E-net.id}"
}

output "aws_s3_bucket_tfer--capui-002E-capstage-002E-net_id" {
  value = "${aws_s3_bucket.tfer--capui-002E-capstage-002E-net.id}"
}

output "cloudfront_OAI_iam_arn" {
    value = "${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"
    description = "The iam_arn of Cloudfront OAI just created for SPA (Single Page App)"
}