variable "region" {
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

#variable "slack_webhook" {
 # description = "Slack Webhook URL"
  #type        = string
#}
