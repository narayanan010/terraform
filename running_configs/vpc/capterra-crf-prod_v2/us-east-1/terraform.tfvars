# AWS infrastructure details
region            = "us-east-1"
availability_zone = "us-east-1a"
monitoring        = true
terraform_managed = true


# Deploymen tag definition
application   = "vpc"
technology    = "vpc"
vertical      = "cap"
stage         = "PRD"
platform      = ""
product       = "capterra"
environment   = "crf"
app_contacts  = "capterra-devops"
function      = "network"
business_unit = "cap-bu"
created_by    = "dan.oliva@gartner.com"

# CloudWatch details
cw_prefix="/aws/vpc/"
cw_logs_retention = 7

