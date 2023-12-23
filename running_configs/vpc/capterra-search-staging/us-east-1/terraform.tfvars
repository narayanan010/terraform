# AWS infrastructure details
region            = "us-east-1"
monitoring        = true
terraform_managed = true


# Deploymen tag definition
application   = "vpc"
technology    = "vpc"
vertical      = "cap"
stage         = "stg"
platform      = ""
product       = "capterra"
environment   = "STAGING"
app_contacts  = "capterra-devops"
function      = "network"
business_unit = "cap-bu"
created_by    = "dan.oliva@gartner.com"

# CloudWatch details
cw_prefix="/aws/vpc/"
cw_logs_retention = 7

