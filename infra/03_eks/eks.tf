locals {
    env           = "dev"
    region        = "eu-west-1"
    cluster_name  = "eks-cluster-1"
    repo_name     = "my-app"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.36"

  cluster_name    = local.cluster_name
  cluster_version = "1.32"

  cluster_endpoint_public_access = true

#   # OPTIONAL: In case we want to lock down EKS API
#   cluster_endpoint_public_access = false
#   cluster_endpoint_public_access_cidrs = [module.vpc.private_subnets_cidr_blocks]

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  # EKS Addons
  cluster_addons = {
    coredns                = {
        most_recent = true
    }
    eks-pod-identity-agent = {
        most_recent = true
    }
    kube-proxy             = {
        most_recent = true
    }
    vpc-cni                = {
        most_recent = true
    }
  }


#   # OPTIONAL: Extend cluster security group rules, this example open most ports
#   cluster_security_group_additional_rules = {
#     egress_nodes_ephemeral_ports_tcp = {
#       description                = "To node 1025-65535"
#       protocol                   = "tcp"
#       from_port                  = 1025
#       to_port                    = 65535
#       type                       = "egress"
#       source_node_security_group = true
#     }
#   }

#   # Extend node-to-node security group rules
#   node_security_group_additional_rules = {
#     ingress_self_all = {
#       description = "Node to node all ports/protocols"
#       protocol    = "-1"
#       from_port   = 0
#       to_port     = 0
#       type        = "ingress"
#       self        = true
#     }
#     egress_all = {
#       description      = "Node all egress"
#       protocol         = "-1"
#       from_port        = 0
#       to_port          = 0
#       type             = "egress"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = ["::/0"]
#     }
#   }
#   # ###################################


  vpc_id     = data.aws_vpc.selected.id
  subnet_ids = local.private_subnets
  control_plane_subnet_ids = local.intra_subnets

  self_managed_node_groups = {
    custom-workers = {
      instance_type = "t3.small"

      min_size = 2
      max_size = 5
      desired_size = 2

    #   # OPTIONAL: Additional policies, in this case to manage workers with system manager
    #   iam_role_additional_policies = [
    #     "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    #   ]
    }
  }

  tags = {
    Environment = local.env
    Terraform   = "true"
  }
}
