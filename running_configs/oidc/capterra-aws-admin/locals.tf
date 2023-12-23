locals {
  GitHubOrg = "capterra"
  GitHubRepo = [
    "all-capone",
    "ansible",
    "aws_tools",
    "blog-ui",
    "capterra-devops",
    "capterra-ec2-image-builder",
    "capterra-eks",
    "capterra-search",
    "capterra-static-ui",
    "crf-legacy",
    "click-consumer",
    "compare-ui",
    "conversion-tracking",
    "directory-page-ui",
    "sem-ui",
    "spotlight-ui",
    "terraform",
    "terraform-poc",
    "terraform-vpc",
    "user-workspace"
  ]
  Capterra_AssumeRole = [
    "arn:aws:iam::148797279579:role/assume-capterra-search-dev-admin",
    "arn:aws:iam::176540105868:role/assume-capterra-admin",
    "arn:aws:iam::176540105868:role/assume-capterra-admin-batch",
    "arn:aws:iam::176540105868:role/assume-capterra-capstage-R53-deployer",
    "arn:aws:iam::176540105868:role/assume-capterra-power-user",
    "arn:aws:iam::176540105868:role/assume-eks-dev-cluster-admin",           # eks deployer_role: dev
    "arn:aws:iam::176540105868:role/assume-eks-production-cluster-admin",    # eks deployer_role: production
    "arn:aws:iam::176540105868:role/assume-eks-production-dr-cluster-admin", # eks deployer_role: production-dr
    "arn:aws:iam::176540105868:role/assume-eks-staging-cluster-admin",       # eks deployer_role: staging
    "arn:aws:iam::176540105868:role/cap-svc-gha-terraform-deployer",
    "arn:aws:iam::273213456764:role/assume-capterra-search-staging-admin",
    "arn:aws:iam::273213456764:role/assume-capterra-search-staging-deployer",
    "arn:aws:iam::296947561675:role/assume-capterra-search-prd-admin",
    "arn:aws:iam::296947561675:role/assume-capterra-search-prod-deployer",
    "arn:aws:iam::314485990717:role/assume-capterra-orange-staging-admin-nonmfa",
    "arn:aws:iam::350125959894:role/gdm-admin-access",
    "arn:aws:iam::350125959894:role/gdm-dev-full_role",
    "arn:aws:iam::377773991577:role/capterra-admin-role",
    "arn:aws:iam::738909422062:role/assume-crf-production-admin",
    "arn:aws:iam::888548925459:role/assume-capterra-wordpress-sbox-admin",
    "arn:aws:iam::944864126557:role/assume-capterra-sandbox-admin", # eks deployer_role: sandbox
    "arn:aws:iam::944864126557:role/no-color-staging-admin"
  ]
  GitHubDatabaseRepo = [
    "ppc-databases",
    "ppc-db-app-poc",
    "ppc-pg-rds-deployments"
  ]
  Capterra_Databases_AssumeRole = [
    "arn:aws:iam::944864126557:role/assume-capterra-sandbox-admin"
  ]
  DynamodbTable        = "capterra-terraform-lock-table"
  TerraformStateBucket = "capterra-terraform-state"
}
