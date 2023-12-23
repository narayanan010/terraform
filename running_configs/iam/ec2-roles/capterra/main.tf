resource "aws_iam_role" "AmazonSSMRoleForInstancesQuickSetup" {
  name        = "AmazonSSMRoleForInstancesQuickSetup"
  description = "EC2 role for SSM for Quick-Setup"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}


resource "aws_iam_instance_profile" "AmazonSSMRoleForInstancesQuickSetup" {
  name = "AmazonSSMRoleForInstancesQuickSetup"
  role = aws_iam_role.AmazonSSMRoleForInstancesQuickSetup.name
}


resource "aws_iam_role" "assets-s3-full-access" {
  name        = "assets-s3-full-access"
  description = "Allows EC2 instances to call AWS services on your behalf."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::176540105868:policy/capterra-pol-eloqua-reviews-connection",
    "arn:aws:iam::176540105868:policy/capterra-role-crf-dynamo-db-access-staging"
  ]
}


resource "aws_iam_instance_profile" "assets-s3-full-access" {
  name = "assets-s3-full-access"
  role = aws_iam_role.assets-s3-full-access.name
}


resource "aws_iam_role" "cap-role-jenkins-ec2-instance-profile" {
  name        = "cap-role-jenkins-ec2-instance-profile"
  description = "Allows EC2 instances to call AWS services on your behalf."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    "arn:aws:iam::176540105868:policy/cap-pol-jenkins-s3-access"
  ]
}


resource "aws_iam_instance_profile" "cap-role-jenkins-ec2-instance-profile" {
  name = "cap-role-jenkins-ec2-instance-profile"
  role = aws_iam_role.cap-role-jenkins-ec2-instance-profile.name
}


resource "aws_iam_role" "capterra-ec2-role" {
  name        = "capterra-ec2-role"
  description = ""

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
  ]

  inline_policy {
    name   = "cap-pol-jenkins-capui-access"
    policy = data.aws_iam_policy_document.cap-pol-jenkins-capui-access.json
  }
}


resource "aws_iam_instance_profile" "capterra-ec2-role" {
  name = "capterra-ec2-role"
  role = aws_iam_role.capterra-ec2-role.name
}


resource "aws_iam_instance_profile" "capterra_ec2_instance_profile_jenkins" {
  name = "capterra_ec2_instance_profile_jenkins"
  role = aws_iam_role.capterra-ec2-role.name
}


resource "aws_iam_role" "capterra-s3-role" {
  name        = "capterra-s3-role"
  description = ""

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/IAMReadOnlyAccess",
    "arn:aws:iam::aws:policy/ResourceGroupsandTagEditorFullAccess",
    "arn:aws:iam::176540105868:policy/Capterra-Athena-Policy",
    "arn:aws:iam::176540105868:policy/CapterraDataArchiveS3Access",
    "arn:aws:iam::176540105868:policy/s3copy_for_equinix-storagegateway-prod_to_gdm-capterra-db-backup",
    "arn:aws:iam::176540105868:policy/capterra-pol-s3-read-access",
    "arn:aws:iam::176540105868:policy/capterra-oracle-db-backup-kms-access"
  ]

  inline_policy {
    name   = "s3cp_fr_equinix-storagegateway-prod_to_gdm-capterra-db-backup-rep_and_eq-gw-prd-rep"
    policy = data.aws_iam_policy_document.s3cp_fr_equinix-storagegateway-prod_to_gdm-capterra-db-backup-rep_and_eq-gw-prd-rep.json
  }

  inline_policy {
    name   = "ssm_db_inline_pol"
    policy = data.aws_iam_policy_document.ssm_db_inline_pol.json
  }
}


resource "aws_iam_instance_profile" "capterra-s3-role" {
  name = "capterra-s3-role"
  role = aws_iam_role.capterra-s3-role.name
}


resource "aws_iam_role" "copy-capterra-s3-role-clone" {
  name        = "copy-capterra-s3-role-clone"
  description = "Allows EC2 instances to call AWS services on your behalf."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = [
            "ec2.amazonaws.com",
            "ssm.amazonaws.com"
          ]
        }
      },
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/IAMReadOnlyAccess",
    "arn:aws:iam::aws:policy/ResourceGroupsandTagEditorFullAccess",
    "arn:aws:iam::176540105868:policy/Capterra-Athena-Policy",
    "arn:aws:iam::176540105868:policy/CapterraDataArchiveS3Access",
    "arn:aws:iam::176540105868:policy/s3copy_for_equinix-storagegateway-prod_to_gdm-capterra-db-backup",
    "arn:aws:iam::176540105868:policy/capterra-pol-s3-read-access",
    "arn:aws:iam::176540105868:policy/capterra-oracle-db-backup-kms-access"
  ]

  inline_policy {
    name   = "clone_s3cp_fr_equinix-storagegateway-prod_to_gdm-capterra-db-backup-rep_and_eq-gw-prd-rep"
    policy = data.aws_iam_policy_document.s3cp_fr_equinix-storagegateway-prod_to_gdm-capterra-db-backup-rep_and_eq-gw-prd-rep.json
  }

  inline_policy {
    name   = "ssm_db_inline_pol"
    policy = data.aws_iam_policy_document.ssm_db_inline_pol.json
  }

  tags = {
    "ENV" = "test"
  }
}


resource "aws_iam_instance_profile" "copy-capterra-s3-role-clone" {
  name = "copy-capterra-s3-role-clone"
  role = aws_iam_role.copy-capterra-s3-role-clone.name
}


resource "aws_iam_role" "CapterraAnalyticsEc2Role" {
  name        = "CapterraAnalyticsEc2Role"
  description = "Allows EC2 instances to call AWS services on your behalf."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    "arn:aws:iam::176540105868:policy/cap-pol-analytics-iam-role"
  ]
}


resource "aws_iam_instance_profile" "CapterraAnalyticsEc2Role" {
  name = "CapterraAnalyticsEc2Role"
  role = aws_iam_role.CapterraAnalyticsEc2Role.name
}


resource "aws_iam_role" "CapterraBadgeLogstashInstanceProfile" {
  name        = "CapterraBadgeLogstashInstanceProfile"
  description = "Allows EC2 instances to call AWS services on your behalf."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::176540105868:policy/capterra-pol-badgelp-access"
  ]
}


resource "aws_iam_instance_profile" "CapterraBadgeLogstashInstanceProfile" {
  name = "CapterraBadgeLogstashInstanceProfile"
  role = aws_iam_role.CapterraBadgeLogstashInstanceProfile.name
}


resource "aws_iam_role" "capterra_base_iam_role" {
  name        = "capterra_base_iam_role"
  description = "Base Role that allows SSM to manage an instance. This should be replaced by an app specific role if acceess to AWS services is needed."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
  ]

  inline_policy {
    name   = "capterra-pol-access-ssm-s3-bucket"
    policy = data.aws_iam_policy_document.capterra-pol-access-ssm-s3-bucket.json
  }
  tags = {
    "CreatorAutoTag" = "cscharding"
    "CreatorId"      = "AROAIEUN4EZ4YR6QDZPHO"
  }
}


resource "aws_iam_instance_profile" "capterra_base_iam_role" {
  name = "capterra_base_iam_role"
  role = aws_iam_role.capterra_base_iam_role.name
}


resource "aws_iam_role" "CloudWatchAgentServerRole" {
  name        = "CloudWatchAgentServerRole"
  description = "Allow CloudWatch Agent to report memory and disk statistics to CloudWatch.  Added by MP 3.20.2018"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonSSMFullAccess",
    "arn:aws:iam::176540105868:policy/cap-pol-enable-ec2-serial-console",
    "arn:aws:iam::176540105868:policy/capterra-pol-access-ssm-docs"
  ]
}


resource "aws_iam_instance_profile" "CloudWatchAgentServerRole" {
  name = "CloudWatchAgentServerRole"
  role = aws_iam_role.CloudWatchAgentServerRole.name
}


resource "aws_iam_role" "ecsInstanceRole" {
  name        = "ecsInstanceRole"
  description = ""

  assume_role_policy = jsonencode({
    Version = "2008-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Sid = ""
      },
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  ]

  inline_policy {
    name   = "policygen-access-to-cloudwatch-logs"
    policy = data.aws_iam_policy_document.policygen-access-to-cloudwatch-logs.json
  }

  inline_policy {
    name   = "policygen-ecsInstanceRole-201704040930"
    policy = data.aws_iam_policy_document.policygen-ecsInstanceRole-201704040930.json
  }
}


resource "aws_iam_instance_profile" "ecsInstanceRole" {
  name = "ecsInstanceRole"
  role = aws_iam_role.ecsInstanceRole.name
}


resource "aws_iam_role" "mgmt-box-EC2-role" {
  name        = "mgmt-box-EC2-role"
  description = "Allows EC2 instances to call AWS services on your behalf."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/AutoScalingReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  ]

  inline_policy {
    name   = "ALBDescribeAccess"
    policy = data.aws_iam_policy_document.ALBDescribeAccess.json
  }

  inline_policy {
    name   = "capterra-cloudtrail-put-object"
    policy = data.aws_iam_policy_document.capterra-cloudtrail-put-object.json
  }

  inline_policy {
    name   = "DeployIAMPermissions"
    policy = data.aws_iam_policy_document.DeployIAMPermissions.json
  }

  inline_policy {
    name   = "machinelearning-privs"
    policy = data.aws_iam_policy_document.machinelearning-privs.json
  }

  inline_policy {
    name   = "manage-ECS-and-deploy-permissions"
    policy = data.aws_iam_policy_document.manage-ECS-and-deploy-permissions.json
  }
}


resource "aws_iam_instance_profile" "mgmt-box-EC2-role" {
  name = "mgmt-box-EC2-role"
  role = aws_iam_role.mgmt-box-EC2-role.name
}
