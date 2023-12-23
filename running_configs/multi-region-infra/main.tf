terraform {
  backend "s3" {}
  
}

data "aws_caller_identity" "current" {}


provider "aws" {
    region = "us-west-2"
    assume_role {
      role_arn     = "arn:aws:iam::176540105868:role/assume-capterra-admin"     
  }
  
}

#This will allow commands to run in us-east-1 where needed"
provider "aws" {
    alias   = "capterra-east"
    region = "us-east-1"
    assume_role {
      role_arn     = "arn:aws:iam::176540105868:role/assume-capterra-admin"     
  }
  
}





