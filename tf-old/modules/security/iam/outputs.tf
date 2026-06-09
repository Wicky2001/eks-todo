output "eks_cluster_control_plane_role_arn" {
  description = "The ARN of the EKS Cluster Control Plane Role"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "eks_cluster_node_role_arn" {
  description = "The ARN of the EKS Cluster Node Role"
  value       = aws_iam_role.eks_node_role.arn
}