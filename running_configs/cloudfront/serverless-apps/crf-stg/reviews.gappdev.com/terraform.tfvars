# AWS infrastructure details
region                                    = "us-east-1"
monitoring                                = true
terraform_managed                         = true
modulecaller_assume_role_deployer_account = "arn:aws:iam::350125959894:role/gdm-admin-access"

# Distribution
name                     = "reviews.gappdev.com"
aws_wafv2_web_acl_name   = "capterra-crf-staging-waf"
origin_bucket_name       = "central-review-form-stg"
origin_cdn_bucket_name   = "crf-staging-cdn"
cf_origin_access_control = "E1B2QERXNS9EWK"

# Deploymen tag definition
application   = "crf"
vertical      = "getapp"
product       = "getapp"
environment   = "staging"
app_contacts  = "capterra-devops"
function      = "cache"
business_unit = "cap-bu"
created_by    = "narayanan.narasimhan@gartner.com"
