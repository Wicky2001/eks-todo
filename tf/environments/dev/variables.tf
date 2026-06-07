variable  "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
    description = "AWS CLI profile to use for credentials"
    type        = string
    default     = "todo-terraform-user"
}

variable "project_name" {
    description = "Name of the project to be used in resource naming"
    type        = string
    default     = "todo-app"
}

variable "environment" {
    description = "Deployment environment (e.g., dev, staging, prod)"
    type        = string
    default     = "dev"

}