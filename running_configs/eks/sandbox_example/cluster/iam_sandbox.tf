data "aws_caller_identity" "deployer" {}
data "aws_caller_identity" "landing" {
  provider = aws.landing-account
}


# Create all Policies in Landing Account
#############################################

## ADMIN
resource "aws_iam_policy" "capterra-pol-assume-eks-sandbox-cluster-admin" {
  provider = aws.landing-account

  name        = "capterra-pol-assume-eks-sandbox-cluster-admin"
  description = "This policy supports assuming role that provides admin access over the staging EKS cluster"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : "sts:AssumeRole",
          "Resource" : "arn:aws:iam::${data.aws_caller_identity.landing.account_id}:role/assume-eks-${var.environment}-cluster-admin"
        }
      ]
    }
  )
}


## EDIT
resource "aws_iam_policy" "capterra-pol-assume-eks-sandbox-cluster-edit" {
  provider = aws.landing-account

  name        = "capterra-pol-assume-eks-sandbox-cluster-edit"
  description = "This policy supports assuming role that provides edit access to sandbox EKS cluster"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : "sts:AssumeRole",
          "Resource" : "arn:aws:iam::${data.aws_caller_identity.landing.account_id}:role/assume-eks-${var.environment}-cluster-edit-role"
        }
      ]
    }
  )
}

## GENERAL-ADMIN
resource "aws_iam_policy" "capterra-pol-assume-eks-sandbox-cluster-general-admin" {
  provider = aws.landing-account

  name        = "capterra-pol-assume-eks-sandbox-cluster-general-admin"
  description = "This policy supports assuming role that provides admin access to sandbox EKS cluster. This is not cluster-admin role But just admin role in Kubernetes"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : "sts:AssumeRole",
          "Resource" : "arn:aws:iam::${data.aws_caller_identity.landing.account_id}:role//assume-eks-${var.environment}-cluster-general-admin"
        }
      ]
    }
  )
}

## CLUSTER-VIEW
resource "aws_iam_policy" "capterra-pol-assume-eks-sandbox-cluster-view" {
  provider = aws.landing-account

  name        = "capterra-pol-assume-eks-sandbox-cluster-view"
  description = "This policy supports assuming role that provides view access to Staging EKS cluster"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : "sts:AssumeRole",
          "Resource" : "arn:aws:iam::${data.aws_caller_identity.landing.account_id}:role/assume-eks-${var.environment}-cluster-view-role"
        }
      ]
    }
  )
}


# Create all Policies in Deployer Account
#############################################

resource "aws_iam_policy" "eks-kubeconfig-describe-sandbox-cluster-eks" {
  name        = "eks-kubeconfig-describe-sandbox-cluster-eks"
  description = ""

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : "eks:DescribeCluster",
          "Resource" : "arn:aws:eks:${var.region}:${data.aws_caller_identity.deployer.account_id}:cluster/${var.eks_name}"
        }
      ]
    }
  )
}



# Create all Roles in Deployer Account & attachment
#############################################

## ADMIN
resource "aws_iam_role" "assume-eks-sandbox-cluster-admin" {
  name = "assume-eks-sandbox-cluster-admin"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : "arn:aws:iam::${data.aws_caller_identity.landing.account_id}:root"
          },
          "Action" : "sts:AssumeRole",
          "Condition" : {}
        }
      ]
    }
  )
}

## EDITOR
resource "aws_iam_role" "assume-eks-sandbox-cluster-edit-role" {
  name = "assume-eks-sandbox-cluster-edit-role"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : "arn:aws:iam::${data.aws_caller_identity.landing.account_id}:root"
          },
          "Action" : "sts:AssumeRole",
          "Condition" : {}
        }
      ]
    }
  )
}


## GENERAL-ADMIN
resource "aws_iam_role" "assume-eks-sandbox-cluster-general-admin-role" {
  name = "assume-eks-sandbox-cluster-general-admin-role"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : "arn:aws:iam::${data.aws_caller_identity.landing.account_id}:root"
          },
          "Action" : "sts:AssumeRole",
          "Condition" : {}
        }
      ]
    }
  )
}

## CLUSTER-VIEW
resource "aws_iam_role" "assume-eks-sandbox-cluster-view-role" {
  name = "assume-eks-sandbox-cluster-view-role"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : "arn:aws:iam::${data.aws_caller_identity.landing.account_id}:root"
          },
          "Action" : "sts:AssumeRole",
          "Condition" : {}
        }
      ]
    }
  )
}

## DEPLOYER
resource "aws_iam_role" "assume-capterra-eks-deploy-sandbox" {
  name = "assume-capterra-eks-deploy-sandbox"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : "arn:aws:iam::${data.aws_caller_identity.landing.account_id}:root"
          },
          "Action" : "sts:AssumeRole",
          "Condition" : {}
        }
      ]
    }
  )
}


# locals {
#   rolelist = [
#     "assume-eks-sandbox-cluster-admin",
#     "assume-eks-sandbox-cluster-edit-role",
#     "assume-eks-sandbox-cluster-general-admin-role",
#     "assume-eks-sandbox-cluster-view-role"
#   ]
# }

# Pending create a loop
resource "aws_iam_role_policy_attachment" "assume-eks-sandbox-cluster-admin" {
  role       = aws_iam_role.assume-eks-sandbox-cluster-admin.name
  policy_arn = aws_iam_policy.eks-kubeconfig-describe-sandbox-cluster-eks.arn
}

resource "aws_iam_role_policy_attachment" "assume-eks-sandbox-cluster-edit-role" {
  role       = aws_iam_role.assume-eks-sandbox-cluster-edit-role.name
  policy_arn = aws_iam_policy.eks-kubeconfig-describe-sandbox-cluster-eks.arn
}

resource "aws_iam_role_policy_attachment" "assume-eks-sandbox-cluster-general-admin-role" {
  role       = aws_iam_role.assume-eks-sandbox-cluster-general-admin-role.name
  policy_arn = aws_iam_policy.eks-kubeconfig-describe-sandbox-cluster-eks.arn
}

resource "aws_iam_role_policy_attachment" "assume-eks-sandbox-cluster-view-role" {
  role       = aws_iam_role.assume-eks-sandbox-cluster-view-role.name
  policy_arn = aws_iam_policy.eks-kubeconfig-describe-sandbox-cluster-eks.arn
}
