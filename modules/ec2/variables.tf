variable "aws_region" {
  description = "AWS region"
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
}

variable "environment" {
  description = "Environment (staging or production)"
}