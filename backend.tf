provider "aws" {
  region = "us-east-1"
}

terraform {
  required_version = "~> 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "tofu-s3-bucket-state"
    key            = "workspaces/aws-secuirty-tf"
    dynamodb_table = "terraform-state-lock-dynamo"
    region         = "us-east-1"
  }
}