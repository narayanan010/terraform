# AWS infrastructure details
region                                    = "us-east-1"
monitoring                                = true
terraform_managed                         = true
modulecaller_assume_role_deployer_account = "arn:aws:iam::350125959894:role/gdm-admin-access"

# Distribution
name                     = "reviews.capstage.net"
aws_wafv2_web_acl_name   = "capterra-crf-staging-waf"
cf_origin_access_control = "E1B2QERXNS9EWK"

# Deploymen tag definition
application   = "crf"
vertical      = "capterra"
product       = "capterra"
environment   = "staging"
app_contacts  = "capterra-devops"
function      = "cache"
business_unit = "cap-bu"
created_by    = "narayanan.narasimhan@gartner.com"
