
# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_guardduty_detector" "example" {
  enable = true
  finding_publishing_frequency = "SIX_HOURS"
  tags = {
    Name = "myGuardDutyDetector"
  }
}
