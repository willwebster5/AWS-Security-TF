

# Lambda Function
resource "aws_lambda_function" "guardduty_lambda" {
  filename      = "GuardDutyLambdas/SSHBruteForceLambda.zip"
  function_name = "GuardDuty_SSHBruteForce"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "SSHBruteForceLambda.lambda_handler"
  runtime       = "python3.8"
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
  inline_policy {
    name   = "lambda_s3_ssm_policy"
    policy = data.aws_iam_policy_document.lambda_exec_policy.json
  }
}

# Update the IAM policy to include S3 and SSM permissions
data "aws_iam_policy_document" "lambda_exec_policy" {
  statement {
    actions = [
      "ssm:SendCommand",
      "ssm:ListCommands",
      "ssm:ListCommandInvocations",
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:ssm:*:*:document/*",
      "arn:aws:ssm:*:*:instance/*",
      "arn:aws:s3:::SSHBruteForceResponseAuthBucket/*",
      "arn:aws:s3:::SSHBruteForceResponseAuthBucket"
    ]
  }
}

# EventBridge Rule
resource "aws_cloudwatch_event_rule" "guardduty_event_rule" {
  name        = "guardduty-event-rule"
  description = "GuardDuty SSH Brute Force Rule"
  event_pattern = jsonencode({
    "source" : ["aws.guardduty"],
    "detail-type" : ["GuardDuty Finding"],
    "detail" : {
      "finding-type" : ["UnauthorizedAccess:EC2/SSHBruteForce"]
    }
  })
}

resource "aws_cloudwatch_event_target" "guardduty_event_target" {
  rule      = aws_cloudwatch_event_rule.guardduty_event_rule.name
  target_id = "GuardDuty_SSHBruteForce"
  arn       = aws_lambda_function.guardduty_lambda.arn
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket = "SSHBruteForceResponseAuthBucket"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}
#test commit