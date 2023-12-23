resource "aws_s3_bucket" "athena-bucket-sandbox" {
  bucket = "athena-bucket-sandbox"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    NAME = "athena-bucket-sandbox"
  }

  policy = <<POLICY
{
    "Id": "Policy1585211412952",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1585211402590",
            "Action": "s3:*",
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::athena-bucket-sandbox",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::944864126557:root"
                ]
            }
        },
        {
            "Sid": "Stmt1585481521819",
            "Action": "s3:*",
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::athena-bucket-sandbox",
            "Principal": {
                "AWS": ${jsonencode(var.principal_list)}
           }
        }
    ]
}
POLICY
}



resource "aws_s3_bucket" "capterra-terraform-state-944864126557" {
  bucket = "capterra-terraform-state-944864126557"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    NAME = "capterra-terraform-state-944864126557"
  }

  policy = <<POLICY
{
    "Id": "Policy1585211412952",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1585211402590",
            "Action": "s3:*",
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::capterra-terraform-state-944864126557",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::944864126557:root"
                ]
            }
        },
        {
            "Sid": "Stmt1585481521819",
            "Action": "s3:*",
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::capterra-terraform-state-944864126557",
            "Principal": {
                "AWS": ${jsonencode(var.principal_list)}
           }
        }
    ]
}
POLICY
}


resource "aws_s3_bucket" "cptra-logs-staging" {
  bucket = "cptra-logs-staging"
  grant {
    id          = data.aws_canonical_user_id.current_user.id
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
  }

  grant {
    id          = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    NAME        = "cptra-logs-staging"
    Environment = "no_color_staging"
  }

  policy = <<POLICY
{
    "Id": "Policy1585211412952",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1585211402590",
            "Action": "s3:*",
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::cptra-logs-staging",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::944864126557:root"
                ]
            }
        },
        {
            "Sid": "Stmt1585481521819",
            "Action": "s3:*",
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::cptra-logs-staging",
            "Principal": {
                "AWS": ${jsonencode(var.principal_list)}
           }
        }
    ]
}
POLICY
}


resource "aws_s3_bucket" "cptra-cf-logs" {
  bucket = "cptra-cf-logs"
  grant {
    id          = data.aws_canonical_user_id.current_user.id
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
  }

  grant {
    id          = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    NAME = "cptra-cf-logs"
  }

  policy = <<POLICY
{
    "Id": "Policy1585211412952",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1585211402590",
            "Action": "s3:*",
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::cptra-cf-logs",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::944864126557:root"
                ]
            }
        },
        {
            "Sid": "Stmt1585481521819",
            "Action": "s3:*",
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::cptra-cf-logs",
            "Principal": {
                "AWS": ${jsonencode(var.principal_list)}
           }
        }
    ]
}
POLICY
}
