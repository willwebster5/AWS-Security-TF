resource "aws_inspector_assessment_target" "target" {
  name = "inspector-target-${var.environment}"
}

resource "aws_inspector_assessment_template" "template" {
  name       = "inspector-template-${var.environment}"
  target_arn = aws_inspector_assessment_target.target.arn
  duration   = 60

  rules_package_arns = [
    "arn:aws:inspector:us-west-2:758058086616:rulespackage/0-9hgA516p",
    "arn:aws:inspector:us-west-2:758058086616:rulespackage/0-H5hpSawc",
    "arn:aws:inspector:us-west-2:758058086616:rulespackage/0-JJOtZiqQ",
    "arn:aws:inspector:us-west-2:758058086616:rulespackage/0-vg5GGHSD",
  ]
}