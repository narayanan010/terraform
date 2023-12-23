# This section configures AWS config rules and resources needed.
resource "aws_config_config_rule" "accru" {
  name = "check-custom-s3-encryption-on-new-bucket"
  description = "This sets up aws config rule to check whether the encryption is enabled on the S3 bucket"
  source {
    owner             = "CUSTOM_LAMBDA"
    source_identifier = aws_lambda_function.custom-s3-bucket-encryption-check.arn
    source_detail {
	   message_type = "ConfigurationItemChangeNotification"
	   }
  }
  scope {
		compliance_resource_types = ["AWS::S3::Bucket"]
	}
  depends_on = [aws_lambda_permission.custom-s3-bucket-encryption-check]
  # depends_on = [aws_config_configuration_recorder.accre, aws_lambda_permission.alp1]
}

resource "aws_config_config_rule" "accru2" {
  name = "check-custom-s3-policy-exists-on-new-bucket"
  description = "This sets up aws config rule to check whether policy exists on the S3 bucket"
  source {
    owner             = "CUSTOM_LAMBDA"
    source_identifier = aws_lambda_function.custom-s3-bucket-policy-check.arn
    source_detail {
	   message_type = "ConfigurationItemChangeNotification"
	   }
  }
  scope {
		compliance_resource_types = ["AWS::S3::Bucket"]
	}
  depends_on = [aws_lambda_permission.custom-s3-bucket-policy-check]
  # depends_on = [aws_config_configuration_recorder.accre, aws_lambda_permission.alp2]
}

resource "aws_config_config_rule" "accru3" {
  name = "check-custom-ebs-encryption-on-new-volume"
  description = "This sets up aws config rule to check whether encryption is enabled on ebs volumes"
  source {
    owner             = "CUSTOM_LAMBDA"
    source_identifier = aws_lambda_function.custom-ebs-encryption-check.arn
    source_detail {
      message_type = "ConfigurationItemChangeNotification"
    }
  }
  scope {
    compliance_resource_types = ["AWS::EC2::Volume"]
  }
  depends_on = [aws_lambda_permission.custom-ebs-encryption-check]
  # depends_on = [aws_config_configuration_recorder.accre, aws_lambda_permission.alp3]
}
