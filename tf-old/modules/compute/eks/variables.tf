variable "cluster_name" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for EKS"
}

variable "cluster_role_arn" {
  type        = string
  description = "IAM Role ARN for the EKS control plane"
}

variable "node_role_arn" {
  type        = string
  description = "IAM Role ARN for the worker nodes"
}

variable "instance_types" {
  type        = list(string)
  description = "List of instance types for the EKS node group"
}
