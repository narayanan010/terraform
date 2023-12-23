terraform {
  backend "s3" {
    bucket = "capterra-terraform-state-176540105868"
    key    = "DR/EC2/CD1A/us-west-2/terraform.tfstate"
    region = "us-east-1"
    encrypt        = true
    #dynamodb_table = "capterra-terraform-lock-table" 
  }
}