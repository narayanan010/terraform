# AWS infrastructure details
region            = "us-east-1"
monitoring        = true
terraform_managed = true

# EC2 instance details
ec2_security_groups = ["sg-06a8b5b3107c86187"]
ec2_instance_type   = "t3a.small"
ec2_key_name        = "capterra-search-staging-key-ue1"
ec2_ami             = "ami-02eac2c0129f6376b"
ec2_subnets         = "subnet-0272efa24d4855bfb"

# Deploymen tag definition
application   = "deployment"
# technology    = "deployment"
vertical      = "cap"
stage         = "stg"
#platform      = ""
product       = "capterra"
environment   = "STAGING"
app_contacts  = "capterra-devops"
function      = "testfunc"
business_unit = "cap-bu"
created_by    = "dan.oliva@gartner.com"