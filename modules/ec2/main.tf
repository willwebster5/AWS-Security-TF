resource "aws_instance" "instance" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "ec2-${var.environment}"
  }
}

resource "aws_ssm_association" "ssm_association" {
  name        = "AWS-ConfigureAWSPackage"
  targets {
    key    = "InstanceIds"
    values = ["*"]
  }

  parameters = {
    action  = "Install"
    name    = "AmazonCloudWatchAgent"
    version = "latest"
  }
}