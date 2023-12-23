#*************************************************************************************************************************************************************#
#                                                      			       Secret     	                                                                    #
#*************************************************************************************************************************************************************#

# resource "aws_secretsmanager_secret" "rds" {
#   name = "rds_test-secret"
# }

/*resource "aws_secretsmanager_secret_rotation" "rds_rotation" {
  secret_id           = aws_secretsmanager_secret.rds.id
  rotation_lambda_arn = aws_lambda_function.example.arn

  rotation_rules {
    automatically_after_days = 30
  }
}*/

data "aws_secretsmanager_random_password" "rds_master" {
  provider           = aws.primary
  password_length    = 16
  exclude_characters = "^ %+~`#$&*()|[]{}:;,-<>?!'/\\\",=-_"
  exclude_punctuation = true
}

resource "aws_secretsmanager_secret" "rds" {
  provider = aws.primary
  name     = "rds/${var.environment}/${var.vertical}-global-${var.application}/admin"
  # tags = merge(module.tags_resource_module.tags, tomap({
  #   "region" = data.aws_region.primary_current.name
  # }))
  tags = {
    "region" = data.aws_region.primary_current.name
  }
}

resource "aws_secretsmanager_secret_version" "rds" {
  provider      = aws.primary
  secret_id     = aws_secretsmanager_secret.rds.id
  secret_string = jsonencode({ username = "dba", password = "${data.aws_secretsmanager_random_password.rds_master.random_password}" })
  lifecycle {
    ignore_changes = [secret_string]
  }
}

resource "aws_secretsmanager_secret_policy" "rds" {
  provider   = aws.primary
  secret_arn = aws_secretsmanager_secret.rds.arn
  policy     = <<POLICY
{
  "Version" : "2012-10-17",
  "Statement" : [ {
    "Sid": "AWSRDSPolicy",
    "Effect" : "Allow",
    "Principal" : {
      "Service" : "rds.amazonaws.com"
    },
    "Action" : "secretsmanager:getSecretValue",
    "Resource" : "${aws_secretsmanager_secret.rds.arn}"
  } ]
}
POLICY
}