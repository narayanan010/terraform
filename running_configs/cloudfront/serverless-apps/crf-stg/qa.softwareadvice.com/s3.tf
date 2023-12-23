data "aws_s3_bucket" "origin" {
  bucket = var.origin_bucket_name
}

data "aws_s3_bucket" "origin_cdn" {
  bucket = var.origin_cdn_bucket_name
}