locals {
  workspace_validation = (run_cmd("terraform", "workspace", "show") == "dev") || (run_cmd("terraform", "workspace", "show") == "staging") || (run_cmd("terraform", "workspace", "show") == "prod") ? true : false
  active_workspace = run_cmd("terraform", "workspace", "show")
  state_key = run_cmd("terraform", "workspace", "show") == "default" ? "${basename(get_parent_terragrunt_dir())}/${path_relative_to_include()}/${local.active_workspace}/terraform.tfstate" : "terraform.tfstate"
}

terraform {
  before_hook "workpace_validation" {
    commands = ["plan","apply","validate"]
    execute  = local.workspace_validation ? ["echo", "=== Workspace active: ${local.active_workspace}"] : [false]
    run_on_error = true
  }
  after_hook "workpace_error" {
    commands = ["plan","apply","validate"]
    execute  = local.workspace_validation == false ? ["echo", "=== Error: Invalid Workspace selected: ${local.active_workspace}"] : [true]
    run_on_error = true
  }
}

remote_state {
    backend = "s3"
    config = {
      bucket               = "capterra-terraform-state"      
      region               = "us-east-1"
      encrypt              = true
      dynamodb_table       = "capterra-terraform-lock-table"
      key                  = local.state_key
      workspace_key_prefix = "${basename(get_parent_terragrunt_dir())}/${path_relative_to_include()}"
    }
}
