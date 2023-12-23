resource "aws_s3_bucket" "bi-export" {
  bucket        = "capterra-bi-data-export"
  force_destroy = "false"
  request_payer = "BucketOwner"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  grant {
    type        = "CanonicalUser"
    permissions = ["READ", "WRITE"]
    id          = "c768943f39940f1a079ee0948ab692883824dcb6049cdf3d7725691bf4f31cbb"
  }

  tags = {
    application = "bi"
    created_by  = "james.nurmi@gartner.com"
    function    = "scalyr-export"
  }

  versioning {
    enabled    = "true"
    mfa_delete = "false"
  }

  replication_configuration {
    role = "arn:aws:iam::176540105868:role/service-role/s3crr_role_for_capterra-bi-data-export"

    rules {
      id       = "capterra-bi-data-export-rep"
      priority = 0
      status   = "Enabled"

      destination {
        bucket = "arn:aws:s3:::capterra-bi-data-export-rep"
      }

      filter {}
    }
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access_bi-export" {
  bucket = aws_s3_bucket.bi-export.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "bi-export-rep" {
  bucket        = "capterra-bi-data-export-rep"
  force_destroy = "false"
  request_payer = "BucketOwner"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  grant {
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
    id          = "c768943f39940f1a079ee0948ab692883824dcb6049cdf3d7725691bf4f31cbb"
  }

  grant {
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
    id          = "9d0dbc9fb3a2bbe784e568c96a7fd3ef55215e4a4960c088986defcf532b852a"
  }

  tags = {
    CreatorAutoTag = "AROASSGU4HSGM2A3FKK3R"
    CreatorId  = "Colin.Taras@gartner.com"
  }

  versioning {
    enabled    = "true"
    mfa_delete = "false"
  }

  lifecycle_rule {
    abort_incomplete_multipart_upload_days = 30
    enabled                                = true
    id                                     = "Replicated files expiration" 
    prefix                                 = "capterra.com/googlebot-exports/" 

    expiration {
      days                         = 0
      expired_object_delete_marker = true
    }

    noncurrent_version_expiration {
      days = 30
    }
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access_bi-export-rep" {
  bucket = aws_s3_bucket.bi-export-rep.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bi-export.id


  lambda_function {
    lambda_function_arn = aws_lambda_function.external_replication.arn
    events              = ["s3:ObjectCreated:*"]

  }
}

resource "null_resource" "build" {
  triggers = {
    sha256 = filebase64sha256("x-acct-copy/index.go")
  }

  provisioner "local-exec" {
    command = "cd x-acct-copy && GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o s3-xacct-copier index.go"
  }
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "x-acct-copy/s3-xacct-copier"
  output_path = "x-acct-copy.zip"
  depends_on  = [null_resource.build]
}


resource "aws_lambda_function" "external_replication" {
  filename         = data.archive_file.lambda.output_path
  function_name    = "replicate-s3-to-external"
  role             = aws_iam_role.external_replicator.arn
  handler          = "s3-xacct-copier"
  source_code_hash = data.archive_file.lambda.output_base64sha256
  architectures    = ["x86_64"]
  runtime          = "go1.x"

  environment {
    variables = {
      DESTINATION_BUCKET = "dm-capterra-bi-dashboard-prod"
      DESTINATION_PREFIX = "uploads_from_scalyr"
      DESTINATION_ROLE   = "arn:aws:iam::933445003212:role/dm-prod-cap-s3-crossaccount"
      DESTINATION_REGION = "us-east-1"
    }
  }

  lifecycle {
    ignore_changes = [source_code_hash]
  }

  depends_on = [data.archive_file.lambda]
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.external_replication.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bi-export.arn
}
