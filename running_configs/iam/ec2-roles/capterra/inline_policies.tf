data "aws_iam_policy_document" "cap-pol-jenkins-capui-access" {
  statement {
    sid = "VisualEditor0"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObjectVersion",
      "s3:ListBucket",
      "s3:DeleteObject",
      "s3:GetObjectVersion"
    ]

    resources = [
      "arn:aws:s3:::capui.capstage.net/*",
      "arn:aws:s3:::capui.capstage.net"
    ]
  }

  statement {
    sid = "VisualEditor1"

    actions = [
      "s3:ListAllMyBuckets",
      "s3:HeadBucket"
    ]

    resources = ["*"]
  }
}


data "aws_iam_policy_document" "s3cp_fr_equinix-storagegateway-prod_to_gdm-capterra-db-backup-rep_and_eq-gw-prd-rep" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::gdm-capterra-db-backup-rep/*",
      "arn:aws:s3:::equnix-storagegateway-prd-rep/*",
      "arn:aws:s3:::equinix-storagegateway-prod/*"
    ]
  }

  statement {
    actions = [
      "s3:ListBucketMultipartUploads",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts"
    ]

    resources = [
      "arn:aws:s3:::gdm-capterra-db-backup-rep",
      "arn:aws:s3:::gdm-capterra-db-backup-rep/*",
      "arn:aws:s3:::equnix-storagegateway-prd-rep",
      "arn:aws:s3:::equnix-storagegateway-prd-rep/*",
      "arn:aws:s3:::equinix-storagegateway-prod",
      "arn:aws:s3:::equinix-storagegateway-prod/*"
    ]
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["*"]
  }

  statement {
    actions = ["kms:GenerateDataKey"]
    resources = [
      "arn:aws:kms:us-west-2:176540105868:alias/aws/s3",
      "arn:aws:kms:us-east-1:176540105868:key/8d4cf506-5082-4bbb-b216-d3376612d7c6"
    ]
  }
}


data "aws_iam_policy_document" "ssm_db_inline_pol" {
  statement {
    sid = "VisualEditor0"

    actions = [
      "ssm:GetParameterHistory",
      "ssm:GetParametersByPath",
      "ssm:GetParameters",
      "ssm:GetParameter"
    ]

    resources = ["arn:aws:ssm:*:176540105868:parameter/devops/nonprod/database/oracle/*"]
  }

  statement {
    sid = "VisualEditor1"

    actions = [
      "ssm:GetParameterHistory",
      "ssm:GetParametersByPath",
      "ssm:GetParameters",
      "ssm:GetParameter"
    ]

    resources = ["arn:aws:ssm:*:176540105868:parameter/devops/prod/keys/tools/*"]
  }

  statement {
    sid       = "VisualEditor2"
    actions   = ["ssm:DescribeParameters"]
    resources = ["arn:aws:ssm:*:176540105868:parameter/devops/nonprod/database/oracle/*"]
  }
}


data "aws_iam_policy_document" "capterra-pol-access-ssm-s3-bucket" {
  statement {
    sid       = "VisualEditor0"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::capterra-ssm-documents"]
  }

  statement {
    sid = "VisualEditor1"

    actions = [
      "s3:GetObject",
      "s3:GetObjectAcl"
    ]

    resources = ["arn:aws:s3:::capterra-ssm-documents/*"]
  }

  statement {
    sid       = "VisualEditor2"
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["*"]
  }
}


data "aws_iam_policy_document" "policygen-access-to-cloudwatch-logs" {
  statement {
    sid = "Stmt1492434819000"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:DescribeMetricFilters",
      "logs:DescribeSubscriptionFilters",
      "logs:FilterLogEvents",
      "logs:GetLogEvents",
      "logs:PutDestination",
      "logs:PutLogEvents",
      "logs:PutMetricFilter",
      "logs:PutRetentionPolicy",
      "logs:PutSubscriptionFilter"
    ]

    resources = ["*"]
  }
}


data "aws_iam_policy_document" "policygen-ecsInstanceRole-201704040930" {
  statement {
    sid = "Stmt1491312532000"

    actions = [
      "ecs:DescribeClusters",
      "ecs:DescribeContainerInstances",
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeTasks",
      "ecs:ListClusters",
      "ecs:ListContainerInstances",
      "ecs:ListServices",
      "ecs:ListTaskDefinitionFamilies",
      "ecs:ListTaskDefinitions",
      "ecs:ListTasks",
      "ecs:RunTask",
      "ecs:StartTask",
      "ecs:StopTask",
      "ecs:UpdateService"
    ]

    resources = ["*"]
  }
}


data "aws_iam_policy_document" "ALBDescribeAccess" {
  statement {
    sid = "Stmt1500496458000"

    actions = [
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeBundleTasks",
      "ec2:DescribeClassicLinkInstances",
      "ec2:DescribeConversionTasks",
      "ec2:DescribeCustomerGateways",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeExportTasks",
      "ec2:DescribeFlowLogs",
      "ec2:DescribeFpgaImages",
      "ec2:DescribeHosts",
      "ec2:DescribeHostReservations",
      "ec2:DescribeHostReservationOfferings",
      "ec2:DescribeIamInstanceProfileAssociation",
      "ec2:DescribeIdentityIdFormat",
      "ec2:DescribeIdFormat",
      "ec2:DescribeImageAttribute",
      "ec2:DescribeImages",
      "ec2:DescribeImportImageTasks",
      "ec2:DescribeImportSnapshotTasks",
      "ec2:DescribeInstanceAttribute",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeInstances",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeMovingAddresses",
      "ec2:DescribeNatGateways",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribePlacementGroups",
      "ec2:DescribeRegions",
      "ec2:DescribeReservedInstances",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVolumeAttribute",
      "ec2:DescribeVolumesModifications",
      "ec2:DescribeVolumeStatus",
      "ec2:DescribeVolumes",
      "ec2:DescribeVpcAttribute"
    ]

    resources = ["*"]
  }

  statement {
    sid = "Stmt1500496622000"

    actions = [
      "elasticloadbalancing:DescribeInstanceHealth",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeLoadBalancerPolicyTypes",
      "elasticloadbalancing:DescribeLoadBalancerPolicies",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeSSLPolicies",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:DetachLoadBalancerFromSubnets"
    ]

    resources = ["*"]
  }
}


data "aws_iam_policy_document" "capterra-cloudtrail-put-object" {
  statement {
    sid = "Stmt1503957063000"

    actions = [
      "s3:AbortMultipartUpload",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:PutObjectTagging",
      "s3:PutObjectVersionAcl",
      "s3:PutObjectVersionTagging"
    ]

    resources = ["arn:aws:s3:::capterra-cloudtrail/*"]
  }
}


data "aws_iam_policy_document" "DeployIAMPermissions" {
  statement {
    sid = "Stmt1500485595000"

    actions = ["iam:PassRole"]

    resources = ["arn:aws:iam::176540105868:role/dockerRole*"]
  }
}


data "aws_iam_policy_document" "machinelearning-privs" {
  statement {
    sid = "Stmt1504025583000"

    actions = ["machinelearning:Predict"]

    resources = ["*"]
  }
}


data "aws_iam_policy_document" "manage-ECS-and-deploy-permissions" {
  statement {
    sid = "Stmt1500413558000"

    actions = [
      "ecs:DeregisterContainerInstance",
      "ecs:DeregisterTaskDefinition",
      "ecs:DescribeClusters",
      "ecs:DescribeContainerInstances",
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeTasks",
      "ecs:DiscoverPollEndpoint",
      "ecs:ListClusters",
      "ecs:ListContainerInstances",
      "ecs:ListServices",
      "ecs:ListTaskDefinitionFamilies",
      "ecs:ListTaskDefinitions",
      "ecs:ListTasks",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:RegisterTaskDefinition",
      "ecs:RunTask",
      "ecs:StartTask",
      "ecs:StopTask",
      "ecs:StartTelemetrySession",
      "ecs:SubmitContainerStateChange",
      "ecs:SubmitTaskStateChange",
      "ecs:UpdateContainerAgent",
      "ecs:UpdateService"
    ]

    resources = ["*"]
  }
}
