resource "aws_s3_bucket_policy" "sem-ui-prd-bucket-policy" {
  provider = aws
  bucket   = "sem-ui-prd"
  policy   = "{\"Id\":\"PolicyForCloudFrontPrivateContent\",\"Statement\":[{\"Action\":\"s3:GetObject\",\"Condition\":{\"StringEquals\":{\"AWS:SourceArn\":\"arn:aws:cloudfront::296947561675:distribution/E2NTTUAKIRGN2F\"}},\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudfront.amazonaws.com\"},\"Resource\":\"arn:aws:s3:::sem-ui-prd/*\",\"Sid\":\"AllowCloudFrontServicePrincipal\"}],\"Version\":\"2008-10-17\"}"
}
