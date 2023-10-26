resource "aws_ssm_patch_baseline" "baseline" {
  name             = "patch-baseline-${var.environment}"
  description      = "Patch baseline for ${var.environment} environment"
}

resource "aws_ssm_association" "patch_association" {
  name        = "AWS-ApplyPatchBaseline"
  instance_id = var.instance_id
  parameters = {
    Operation = "Install"
  }
}