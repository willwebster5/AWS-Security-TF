variable "region" {
  description = "AWS region"
  default = "us-east-1"
}

variable "aws_access_key_id" {
  type        = string
  description = "The AWS access key ID for authentication."
}

variable "aws_secret_access_key" {
  type        = string
  description = "The AWS secret access key for authentication."
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  default     = "ami-0dbc3d7bc646e8516"
}

#variable "slack_webhook" {
 # description = "Slack Webhook URL"
  #type        = string
#}
