##
#terragrunt = {
remote_state {
    backend = "s3"
    config = {
      bucket         = "nn-terraform-state"      
      region         = "us-east-1"
      encrypt        = true
      dynamodb_table = "nn-terraform-lock-table"
      key            = "${path_relative_to_include()}/terraform.tfstate"

    }
  }
#}