terragrunt = {
  remote_state {
    backend = "s3"
    config {
      bucket         = "capterra-terraform-state"
      key            = "${path_relative_to_include()}/terraform.tfstate"
      region         = "us-east-1"
      encrypt        = true
      dynamodb_table = "capterra-terraform-lock-table"      

    }
  }
}