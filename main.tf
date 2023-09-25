
# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "aws-secret-tf"
  acl    = "private"
}
