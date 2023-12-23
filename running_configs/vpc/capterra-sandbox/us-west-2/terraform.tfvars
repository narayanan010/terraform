# AWS infrastructure details
region            = "us-west-2"
monitoring        = true
terraform_managed = true


# Deploymen tag definition
application   = "vpc"
technology    = "vpc"
vertical      = "cap"
stage         = "SANDBOX"
platform      = ""
product       = "sandbox"
environment   = "crf"
app_contacts  = "capterra-devops"
function      = "network"
business_unit = "cap-bu"
created_by    = "dan.oliva@gartner.com"

# CloudWatch details
cw_prefix="/aws/vpc/"
cw_logs_retention = 7

