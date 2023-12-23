# AWS infrastructure details
region            = "us-east-1"
monitoring        = true
terraform_managed = true

# EC2 instance details
ec2_security_groups = ["sg-059ec2e895efd59e2"]
ec2_instance_type   = "t3a.small"
ec2_key_name        = "capterra-search-prod-us-east-1"
ec2_ami             = "ami-0adf0d60430955d01"
ec2_subnets         = "subnet-0231e00693814e9ae"

# Deploymen tag definition
application   = "deployment"
technology    = "deployment"
vertical      = "cap"
stage         = "prd"
platform      = ""
product       = "capterra"
environment   = "PRODUCTION"
app_contacts  = "capterra-devops"
function      = "testfunc"
business_unit = "cap-bu"
created_by    = "dan.oliva@gartner.com"