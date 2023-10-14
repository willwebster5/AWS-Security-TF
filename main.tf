
# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_s3_bucket" "New_bucket" {
  bucket = "ENTER YOUR BUCKET NAME"
  acl    = "private"

  tags = {
    Name = "myBucketTagName"
  }
}
