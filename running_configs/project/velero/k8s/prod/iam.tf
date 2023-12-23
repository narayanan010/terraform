data "aws_iam_policy_document" "velero_backup_permissions" {
  statement {
    sid = "Snapshots"
    actions = [
      "ec2:DescribeVolumes",
      "ec2:DescribeSnapshots",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:CreateSnapshot",
      "ec2:DeleteSnapshot"
    ]
    resources = ["*"]
  }

  statement {
    sid = "S3Backups"
    actions = [
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts"
    ]
    resources = ["arn:aws:s3:::capterra-backup/velero-backup/*"]
  }

  statement {
    sid = "S3Access"
    actions = [
      "s3:ListBucket"
    ]
    resources = ["arn:aws:s3:::capterra-backup"]
  }
}
