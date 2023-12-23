# resource "aws_iam_role_policy" "lambda_pxEnforcer" {
#   name_prefix = "AWSLambdaBasicExecutionRole-"
#   role        = aws_iam_role.lambda_pxEnforcer.name
#   policy = jsonencode(
#     {
#       "Version" : "2012-10-17",
#       "Statement" : [
#         {
#           "Effect" : "Allow",
#           "Action" : "logs:CreateLogGroup",
#           "Resource" : "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*"
#         },
#         {
#           "Effect" : "Allow",
#           "Action" : [
#             "logs:CreateLogStream",
#             "logs:PutLogEvents"
#           ],
#           "Resource" : [
#             "${aws_cloudwatch_log_group.cloudfront_pxEnforcer.arn}"
#           ]
#         }
#       ]
#     }
#   )
# }

# resource "aws_iam_role" "lambda_pxEnforcer" {
#   name_prefix = "pxEnforcer-clicks-role-"
#   assume_role_policy = jsonencode(
#     {
#       "Version" : "2012-10-17",
#       "Statement" : [
#         {
#           "Effect" : "Allow",
#           "Principal" : {
#             "Service" : [
#               "lambda.amazonaws.com",
#               "edgelambda.amazonaws.com"
#             ]
#           },
#           "Action" : "sts:AssumeRole"
#         }
#       ]
#     }
#   )
# }