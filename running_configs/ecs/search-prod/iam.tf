data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# IAM Role: EC2
data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_agent" {
  name               = "ecs-agent"
  description        = "Role permissions for EC2 instances"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "ecs-agent"
  role = aws_iam_role.ecs_agent.name

  depends_on = [aws_iam_role.ecs_agent]
}


resource "aws_iam_role_policy_attachment" "ec2_iam_role01" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"

  depends_on = [aws_iam_role.ecs_agent]
}

resource "aws_iam_role_policy_attachment" "ec2_iam_role02" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"

  depends_on = [aws_iam_role.ecs_agent]
}

resource "aws_iam_role_policy_attachment" "ec2_iam_role03" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

  depends_on = [aws_iam_role.ecs_agent]
}


resource "aws_iam_role_policy" "ec2_agent_inline_pol01" {
  name = "ses_policy"
  role = aws_iam_role.ecs_agent.name

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "AuthorizeFromAddress",
          "Effect" : "Allow",
          "Action" : [
            "ses:SendEmail",
            "ses:SendRawEmail"
          ],
          "Resource" : "*",
          "Condition" : {
            "StringEquals" : {
              "ses:FromAddress" : "software@capterra.com"
            }
          }
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "ec2_agent_inline_pol02" {
  name = "dynamo_pol"
  role = aws_iam_role.ecs_agent.name
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "DynamoDBAccess",
          "Effect" : "Allow",
          "Action" : [
            "dynamodb:PutItem",
            "dynamodb:DeleteItem",
            "dynamodb:Scan",
            "dynamodb:UpdateItem",
            "dynamodb:BatchGet*",
            "dynamodb:BatchWrite*",
            "dynamodb:Describe*",
            "dynamodb:Get*",
            "dynamodb:Query"
          ],
          "Resource" : [
            "arn:aws:dynamodb:*:*:table/UserWorkspace*",
            "arn:aws:dynamodb:*:*:table/userworkspace*"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "ec2_agent_inline_pol03" {
  name = "cognito_pol"
  role = aws_iam_role.ecs_agent.name
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "CognitoAccess",
          "Effect" : "Allow",
          "Action" : [
            "cognito-idp:AdminDeleteUser",
            "cognito-idp:ListUsersInGroup",
            "cognito-idp:AdminDeleteUserAttributes",
            "cognito-idp:AdminCreateUser",
            "cognito-idp:UpdateGroup",
            "cognito-idp:AdminDisableUser",
            "cognito-idp:AdminAddUserToGroup",
            "cognito-idp:AdminUpdateUserAttributes",
            "cognito-idp:AdminGetUser",
            "cognito-idp:ListUsers",
            "cognito-idp:DeleteUserAttributes",
            "cognito-idp:GetUser",
            "cognito-idp:UpdateUserAttributes",
            "cognito-idp:VerifyUserAttribute",
            "cognito-idp:DeleteUser",
            "cognito-idp:AdminSetUserPassword"
          ],
          "Resource" : "*",
          "Condition" : {
            "StringLike" : {
              "aws:ResourceTag/Team" : "Spacenine"
            }
          }
        },
      ]
    }
  )
}

# IAM Role: ECS Task
data "aws_iam_policy_document" "ecs_task" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com",
        "application-autoscaling.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "ecs_task" {
  name               = "ECSServiceRole-${var.tag_environment}"
  description        = "Role permissions for ECS Task actions"
  assume_role_policy = data.aws_iam_policy_document.ecs_task.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_managed_pol01" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_managed_pol02" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemFullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_task_managed_pol03" {
  role       = aws_iam_role.ecs_task.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy" "ecs_task_inline_pol01" {
  name = "secretsmanager_pol"
  role = aws_iam_role.ecs_task.name

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : [
            "secretsmanager:GetSecretValue",
            "secretsmanager:ListSecrets"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "ecs_task_inline_pol02" {
  name = "cognito_pol"
  role = aws_iam_role.ecs_task.name
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "CognitoAccess",
          "Effect" : "Allow",
          "Action" : [
            "cognito-idp:AdminDeleteUser",
            "cognito-idp:ListUsersInGroup",
            "cognito-idp:AdminDeleteUserAttributes",
            "cognito-idp:AdminCreateUser",
            "cognito-idp:UpdateGroup",
            "cognito-idp:AdminDisableUser",
            "cognito-idp:AdminAddUserToGroup",
            "cognito-idp:AdminUpdateUserAttributes",
            "cognito-idp:AdminGetUser",
            "cognito-idp:ListUsers",
            "cognito-idp:DeleteUserAttributes",
            "cognito-idp:GetUser",
            "cognito-idp:UpdateUserAttributes",
            "cognito-idp:VerifyUserAttribute",
            "cognito-idp:DeleteUser",
            "cognito-idp:AdminSetUserPassword"
          ],
          "Resource" : "*",
          "Condition" : {
            "StringLike" : {
              "aws:ResourceTag/Team" : "Spacenine"
            }
          }
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "ecs_task_inline_pol03" {
  name = "dynamo_pol"
  role = aws_iam_role.ecs_task.name
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "DynamoDBAccess",
          "Effect" : "Allow",
          "Action" : [
            "dynamodb:PutItem",
            "dynamodb:DeleteItem",
            "dynamodb:Scan",
            "dynamodb:UpdateItem",
            "dynamodb:BatchGet*",
            "dynamodb:BatchWrite*",
            "dynamodb:Describe*",
            "dynamodb:Get*",
            "dynamodb:Query"
          ],
          "Resource" : [
            "arn:aws:dynamodb:*:*:table/UserWorkspace*",
            "arn:aws:dynamodb:*:*:table/userworkspace*"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "ecs_task_inline_pol04" {
  name = "ses_pol"
  role = aws_iam_role.ecs_task.name
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "AuthorizeFromAddress",
          "Effect" : "Allow",
          "Action" : [
            "ses:SendEmail",
            "ses:SendRawEmail"
          ],
          "Resource" : "*",
          "Condition" : {
            "StringEquals" : {
              "ses:FromAddress" : "software@capterra.com"
            }
          }
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "ecs_task_inline_pol05" {
  name = "cw_pol"
  role = aws_iam_role.ecs_task.name
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "CloudWatch",
          "Effect" : "Allow",
          "Action" : [
            "logs:*"
          ],
          "Resource" : [
            "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/ecs/bx-ba-api*"
          ]
        }
      ]
    }
  )
}

# IAM Role: SNS
data "aws_iam_policy_document" "sns_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "sns_role" {
  name               = "lambda-sns"
  description        = "Project bx-ba-api"
  assume_role_policy = data.aws_iam_policy_document.sns_role.json
}


resource "aws_iam_role_policy_attachment" "sns_policy_role01" {
  role       = aws_iam_role.sns_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSNSFullAccess"

  depends_on = [aws_iam_role.sns_role]
}

resource "aws_iam_role_policy_attachment" "sns_policy_role02" {
  role       = aws_iam_role.sns_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"

  depends_on = [aws_iam_role.sns_role]
}

resource "aws_iam_role_policy_attachment" "sns_policy_role03" {
  role       = aws_iam_role.sns_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

  depends_on = [aws_iam_role.sns_role]
}

resource "aws_iam_role_policy_attachment" "sns_policy_role04" {
  role       = aws_iam_role.sns_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"

  depends_on = [aws_iam_role.sns_role]
}

resource "aws_iam_role_policy" "sns_task_inline_pol01" {
  name = "ssm_pol"
  role = aws_iam_role.sns_role.name
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "SSM",
          "Effect" : "Allow",
          "Action" : [
            "ssm:GetParameter"
          ],
          "Resource" : [
            "${aws_ssm_parameter.slack_notify_token.arn}"
          ]
        }
      ]
    }
  )
}
