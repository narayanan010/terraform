# AWS infrastructure details
region            = "us-west-2"
monitoring        = true
terraform_managed = true


# Deploymen tag definition
application   = "vpc"
technology    = "vpc"
vertical      = "cap"
stage         = "PRD"
platform      = ""
product       = "capterra"
environment   = "search"
app_contacts  = "capterra-devops"
function      = "network"
business_unit = "cap-bu"
created_by    = "narayanan.narasimhan@gartner.com"

# CloudWatch details
cw_prefix="/aws/vpc/"
cw_logs_retention = 7

