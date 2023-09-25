provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "mybucket"
    key    = "workspaces/aws-secuirty-tf"
    region = "us-east-1"
  }
}