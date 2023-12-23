resource "aws_secretsmanager_secret" "secrets_graphql" {
  provider = aws.awscaller_account

  name                    = "bx-api-platform_capterra-graphql_${var.tag_app_environment}"
  description             = "Secrets for GraphQL repository: capterra/capterra-graphql"
  recovery_window_in_days = 0

  tags = {
    environment = var.tag_app_environment
    team        = "daylight"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_secretsmanager_secret_version" "secrets_graphql" {
  provider = aws.awscaller_account

  secret_id     = aws_secretsmanager_secret.secrets_graphql.id
  secret_string = <<EOF
  {
    "CAPTERRA_HMAC_KEY": "dummy",
    "ES_API_KEY": "dummy",
    "KAFKA_CERT_PASSWORD": "dummy",
    "NEW_RELIC_LICENSE": "dummy",
    "REDIS_PASSWORD": "dummy",
    "ROLLBAR_ACCESS_TOKEN": "dummy",
    "SECRET_KEY_BASE": "dummy",
    "DATABASE_PASSWORD": "dummy"
  }
EOF

  lifecycle {
    ignore_changes = [secret_string]
  }
}
