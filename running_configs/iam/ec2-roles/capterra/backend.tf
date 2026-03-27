terraform {
    backend "s3" {
        bucket         = "nn-terraform-state"      
        region         = "us-east-1"
        encrypt        = true
        dynamodb_table = "nn-terraform-lock-table"
        key            = "iam/ec2-roles/capterra/test-keys"
    }
}