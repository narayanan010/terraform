resource "aws_s3_bucket_policy" "central-review-form-prd" {
  bucket = aws_s3_bucket.central-review-form-prd.id
  policy = data.aws_iam_policy_document.s3_policy_crf_prd_bucket.json
}

data "aws_iam_policy_document" "s3_policy_crf_prd_bucket" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.central-review-form-prd.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "AWS:SourceArn"

      values = [
        "arn:aws:cloudfront::738909422062:distribution/*"
      ]
    }
  }
}

resource "aws_s3_bucket_policy" "crf-prod-cdn" {
  bucket = aws_s3_bucket.crf-prod-cdn.id
  policy = data.aws_iam_policy_document.crf-prod-cdn-bucket.json
}

data "aws_iam_policy_document" "crf-prod-cdn-bucket" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.crf-prod-cdn.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "AWS:SourceArn"

      values = [
        "arn:aws:cloudfront::738909422062:distribution/*"
      ]
    }
  }
}