variable "region_aws" {
  description = "This is region where tf template is to be deployed"
  default     = "us-east-1"
}

variable "bucket_name" {
	description = "S3-Bucket-name for data upload"
}

variable "vpc_id" {
	description = "VPC ID that needs to be allowed via Network origin VPC via access-point"
}

variable "access_point_name" {
	description = "access_point_name that needs to be created for the bucket"
}

variable "iamusername" {
	description = "iam user that needs to be given access to the bucket and access point via bucket policy and access-point-policy. Eg: test-user"
	default = "iamusername"
}

variable "bucketsubdirname" {
	description = "bucketsubdirname is the name of directory inside S3 bucket that needs to be given access via created Access Point for bucket. Eg: test-dir"
	default = "bucketsubdirname"
}