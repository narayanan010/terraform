provider "aws" {
  region = var.region
  assume_role {
    role_arn = "arn:aws:iam::944864126557:role/assume-capterra-sandbox-admin"
  }
  default_tags {
    tags = module.tags_resource_module.tags
  }

  ignore_tags {
    key_prefixes = ["tags", "tags_all"]
    keys         = ["CreatorAutoTag", "CreatorId", "last_update", "iac_platform"]
  }
}

provider "aws" {
  alias  = "landing-account"
  region = var.region_landing
  default_tags {
    tags = module.tags_resource_module.tags
  }

  ignore_tags {
    key_prefixes = ["tags","tags_all"]
    keys         = ["CreatorAutoTag","CreatorId","last_update","iac_platform"]
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
