# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "EMIUWVHNT1PVW"
resource "aws_cloudfront_origin_access_control" "spotlight_prod_oac" {
  description                       = "OAC for serverless app named capterra-spotlight"
  name                              = "serverless-capterra-spotlight"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
