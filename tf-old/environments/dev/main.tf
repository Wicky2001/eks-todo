terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}


module "vpc" {
  source = "../../modules/networking/vpc"
  project_name = var.project_name
  environment = var.environment
}

module "iam" {
  source = "../../modules/security/iam"
  project_name = var.project_name
}

module "eks" {
  source = "../../modules/compute/eks"
  cluster_name = "${var.project_name}-${var.environment}-eks-cluster"
  kubernetes_version = "1.27"
  cluster_role_arn = module.iam.eks_cluster_control_plane_role_arn
  node_role_arn = module.iam.eks_cluster_node_role_arn
  private_subnet_ids = module.vpc.private_subnet_ids
  instance_types = ["t3.small", "t3.medium"]
}
