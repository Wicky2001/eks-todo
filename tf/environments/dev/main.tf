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


