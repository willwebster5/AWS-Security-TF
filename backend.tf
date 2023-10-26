provider "aws" {
  region                   = var.aws_region
  shared_credentials_files = [".aws/credentials"]
}

terraform {
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
    #access_key = "var.aws_access_key_id"
    #secret_key = "var.aws_secret_access_key"]
    shared_credentials_file = ".aws/credentials"
  }
}