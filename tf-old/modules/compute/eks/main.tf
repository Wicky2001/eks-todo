resource "aws_eks_cluster" "jawsight_cluster" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn # Pulled from variables
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

# EKS Node Group
resource "aws_eks_node_group" "general_purpose" {
  cluster_name    = aws_eks_cluster.jawsight_cluster.name
  node_group_name = "general-purpose"
  node_role_arn   = var.node_role_arn # Pulled from variables
  subnet_ids      = var.private_subnet_ids

  instance_types = var.instance_types

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 1
  }
}