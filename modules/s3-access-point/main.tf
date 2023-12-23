data "aws_caller_identity" "current" {
  provider      = "aws.awscaller_account"
}

provider "aws" {
	#region = "${var.region_aws}"
  alias = "awscaller_account"
}

#This section is for S3 Bucket Creation and reqd. Configurations like KMS
resource "aws_s3_bucket" "as3b" {
provider      = "aws.awscaller_account"
  bucket        = "${var.bucket_name}"
  tags = {
    terraform_managed = "true" 
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.akk.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }
}




#This section is for blocking all s3 public access
resource "aws_s3_bucket_public_access_block" "as3bpab" {
provider      = "aws.awscaller_account"
  bucket = aws_s3_bucket.as3b.id
  # Block new public ACLs and uploading public objects
  block_public_acls = true
  # Retroactively remove public access granted through public ACLs
  ignore_public_acls = true
  # Block new public bucket policies
  block_public_policy = true
  # Retroactivley block public and cross-account access if bucket has public policies
  restrict_public_buckets = true
}




#This section is for S3 Bucket Policy
data "template_file" "s3_bucket_policy" {
  template = "${file("${path.module}/s3-policy.json.tpl")}"
  vars = {
    bucket_name = "${aws_s3_bucket.as3b.id}"
    account_id  = "${data.aws_caller_identity.current.account_id}"
    iamusername = "${var.iamusername}"
  }
}

resource "aws_s3_bucket_policy" "as3bp" {
provider      = "aws.awscaller_account"
  bucket = aws_s3_bucket.as3b.id
  policy = data.template_file.s3_bucket_policy.rendered

  depends_on = ["aws_s3_bucket_public_access_block.as3bpab"]
}




#This section is for S3-Access-Point Configurations
data "template_file" "s3_access_point_policy" {
  template = "${file("${path.module}/s3-access-point-policy.json.tpl")}"
  vars = {
    access_point_name = "${var.access_point_name}"
    account_id        = "${data.aws_caller_identity.current.account_id}"
    region_aws        = "${var.region_aws}"
    iamusername       = "${var.iamusername}"
    bucketsubdirname  = "${var.bucketsubdirname}"
    #access_point_arn = "${aws_s3_access_point.as3ap.arn}"
  }
}

resource "aws_s3_access_point" "as3ap" {
provider      = "aws.awscaller_account"
  bucket = aws_s3_bucket.as3b.id
  name   = "${var.access_point_name}"
  vpc_configuration {
    vpc_id = "${var.vpc_id}"
  }
  policy = data.template_file.s3_access_point_policy.rendered
}




#This section is for KMS CMK for bucket
data "template_file" "kms_policy" {
  template = "${file("${path.module}/kms-policy.json.tpl")}"
  vars = {
    account_id  = "${data.aws_caller_identity.current.account_id}"
    iamusername = "${var.iamusername}"
  }
}

resource "aws_kms_key" "akk" {
provider      = "aws.awscaller_account"
  description             = "This key is used to encrypt bucket objects in Bucket ${var.bucket_name}"
  deletion_window_in_days = 15
  is_enabled              = "true"
  tags = {
    terraform_managed = "true"
    Application       = "s3"
    Bucket            = "${var.bucket_name}"
  }
  policy              = data.template_file.kms_policy.rendered
}

resource "aws_kms_alias" "aka" {
provider      = "aws.awscaller_account"
  name          = "alias/${aws_s3_bucket.as3b.id}"
  target_key_id = "${aws_kms_key.akk.key_id}"
}