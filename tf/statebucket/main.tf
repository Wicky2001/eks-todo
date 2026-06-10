###############################################################################
# Provider
###############################################################################
provider "aws" {
  region              = var.region
  allowed_account_ids = [var.aws_account_id]
  profile             = var.aws_profile
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

###############################################################################
# S3 Bucket
###############################################################################
resource "aws_s3_bucket" "state" {
  bucket        = "terraform-backend-state-file-karpenter"
  force_destroy = true

}
