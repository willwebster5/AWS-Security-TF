
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

module "ec2_staging" {
  source        = "./modules/ec2"
  aws_region    = var.aws_region
  instance_type = var.instance_type
  ami_id        = var.ami_id
  environment   = "staging"
}

module "inspector_staging" {
  source      = "./modules/inspector"
  aws_region  = var.aws_region
  environment = "staging"
}

module "patch_manager_staging" {
  source      = "./modules/patch_manager"
  aws_region  = var.aws_region
  environment = "staging"
}