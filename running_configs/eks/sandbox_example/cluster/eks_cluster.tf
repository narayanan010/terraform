module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.29.1"

  cluster_name                    = var.eks_name
  cluster_version                 = "1.22"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    # coredns = {             # a minimum of 2 cluster nodes are required for addon coredns to meet its requirements for its replica set
    #   resolve_conflicts = "OVERWRITE"
    # }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  cluster_encryption_config = [{
    provider_key_arn = aws_kms_key.eks.arn
    resources        = ["secrets"]
  }]

  cluster_tags = {
    Name = var.eks_name
  }

  vpc_id                    = module.vpc.vpc_id
  subnet_ids                = module.vpc.private_subnets
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  manage_aws_auth_configmap = true

  #   # Self Managed Node Group(s)
  #   self_managed_node_group_defaults = {
  #     instance_type                          = "m6i.small"
  #     update_launch_template_default_version = true
  #     iam_role_additional_policies = [
  #       "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  #     ]
  #   }

  #   self_managed_node_groups = {
  #     one = {
  #       name         = "mixed-1"
  #       max_size     = 3
  #       desired_size = 1

  #       use_mixed_instances_policy = true
  #       mixed_instances_policy = {
  #         instances_distribution = {
  #           on_demand_base_capacity                  = 0
  #           on_demand_percentage_above_base_capacity = 10
  #           spot_allocation_strategy                 = "capacity-optimized"
  #         }

  #         override = [
  #           {
  #             instance_type     = "m5.medium"
  #             weighted_capacity = "1"
  #           },
  #           {
  #             instance_type     = "m6i.medium"
  #             weighted_capacity = "2"
  #           },
  #         ]
  #       }
  #     }
  #   }

  #   # EKS Managed Node Group(s)
  #   eks_managed_node_group_defaults = {
  #     disk_size      = 50
  #     instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  #   }

  #   eks_managed_node_groups = {
  #     blue = {}
  #     green = {
  #       min_size     = 1
  #       max_size     = 3
  #       desired_size = 1

  #       instance_types = ["t3.large"]
  #       capacity_type  = "SPOT"
  #     }
  #   }

  # Fargate Profile(s)
  fargate_profiles = {
    default = {
      name = "default"
      selectors = [
        {
          namespace = "default"
        }
      ]
    }
  }
}

resource "aws_kms_key" "eks" {
  description             = "EKS Secret Encryption Key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}
