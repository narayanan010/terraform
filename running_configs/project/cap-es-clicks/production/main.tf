data "template_file" "ssm_document_file" {
  template      = "${file("ssm_document.yaml")}"
}

resource "aws_ssm_document" "this" {
  name          = "Capterra-CapEsClicks-${var.environment}-uploader-executor"
  document_type = "Command"
  document_format = "YAML"
  content = data.template_file.ssm_document_file.rendered
}

resource "aws_ssm_parameter" "github_ssh_key" {
  name  = "/devops/github/token/capterra/${var.environment}/cap-es-clicks"
  type  = "SecureString"
  value = "changeme"
  lifecycle {
    ignore_changes = [
      value,
    ]
  }
}
