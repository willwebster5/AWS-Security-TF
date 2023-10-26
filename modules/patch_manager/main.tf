resource "aws_ssm_patch_baseline" "baseline" {
  name             = "patch-baseline-${var.environment}"
  description      = "Patch baseline for ${var.environment} environment"
  approved_patches = ["*"]
}

resource "aws_ssm_association" "patch_association" {
  name        = "AWS-ApplyPatchBaseline"
  instance_id = aws_instance.instance.id

  parameters = {
    Operation = "Install"
  }
}