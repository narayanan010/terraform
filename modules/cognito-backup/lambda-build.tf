# Lambda Code Build
resource "null_resource" "executor_code_build" {
  triggers    = {
    sha256    = filebase64sha256("${path.module}/app/executor/requirements.txt")
  }

  provisioner "local-exec" {
    command   = "cd ${path.module}/app/executor && pip3 install --target ./ -r requirements.txt && rm -rf *-info venv .idea"
  }
}

data "archive_file" "cognito_backup_executor_lambda_code" {
  type        = "zip"
  source_dir  = "${path.module}/app/executor"
  output_path = "${path.module}/function-executor.zip"
  depends_on  = [null_resource.executor_code_build]
}

resource "null_resource" "selector_code_build" {
  triggers    = {
    sha256    = filebase64sha256("${path.module}/app/selector/requirements.txt")
  }

  provisioner "local-exec" {
    command   = "cd ${path.module}/app/selector && pip3 install --target ./ -r requirements.txt && rm -rf *-info venv .idea"
  }
}

data "archive_file" "cognito_backup_selector_lambda_code" {
  type        = "zip"
  source_dir  = "${path.module}/app/selector"
  output_path = "${path.module}/function-selector.zip"
  depends_on  = [null_resource.selector_code_build]
}
