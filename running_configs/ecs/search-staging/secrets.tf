resource "aws_secretsmanager_secret" "secrets_uw" {
  name                    = "user-workspace_${var.tag_application}"
  description             = "Secrets for UW repository: capterra/user-workspace"
  recovery_window_in_days = 0

  tags = {
    environment = var.tag_app_environment
    team        = "spacenine"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_secretsmanager_secret_version" "secrets_uw" {
  secret_id     = aws_secretsmanager_secret.secrets_uw.id
  secret_string = file("./source/secrets.json")

  lifecycle {
    ignore_changes = [secret_string]
  }
}
