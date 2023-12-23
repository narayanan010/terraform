# AWS infrastructure details
region                                    = "us-east-1"
monitoring                                = true
terraform_managed                         = true
modulecaller_assume_role_deployer_account = "arn:aws:iam::738909422062:role/assume-crf-production-admin"

# Distribution
name                     = "reviews.upcity.com"
oai                      = "E16H4GJPGRAPB6"
aws_wafv2_web_acl_name   = "capterra-crf-prod-waf"
cf_origin_access_control = "E3HHX2WMEEHOPY"

# Deploymen tag definition
application   = "crf"
vertical      = "upcity"
product       = "upcity"
environment   = "prod"
app_contacts  = "capterra-devops"
function      = "cache"
business_unit = "cap-bu"
created_by    = "narayanan.narasimhan@gartner.com"
