output "aws_cloudfront_distribution_tfer--E2N5WHOMLSGI88_id" {
  value = "${aws_cloudfront_distribution.tfer--E2N5WHOMLSGI88.id}"
}

output "aws_s3_bucket_policy_tfer--gdm-002D-style-002D-guide-002E-capstage-002E-net_id" {
  value = "${aws_s3_bucket_policy.tfer--gdm-002D-style-002D-guide-002E-capstage-002E-net.id}"
}

output "aws_s3_bucket_tfer--gdm-002D-style-002D-guide-002E-capstage-002E-net_id" {
  value = "${aws_s3_bucket.tfer--gdm-002D-style-002D-guide-002E-capstage-002E-net.id}"
}

output "cloudfront_OAI_iam_arn" {
    value = "${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"
    description = "The iam_arn of Cloudfront OAI just created for SPA (Single Page App)"
}