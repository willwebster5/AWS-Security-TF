
/*
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
}

data "aws_iam_policy_document" "lambda_secrets_policy" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
    ]
    resources = [aws_secretsmanager_secret.slack_webhook_secret.arn]
  }
}

resource "aws_iam_policy" "lambda_secrets_policy" {
  name        = "lambda_secrets_policy"
  description = "Allow lambda to access secrets"
  policy      = data.aws_iam_policy_document.lambda_secrets_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_secrets_policy_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_secrets_policy.arn
}

# Secrets Manager for Slack webhook
resource "aws_secretsmanager_secret" "slack_webhook_secret" {
  name = "slack/webhook12422"
}

resource "aws_secretsmanager_secret_version" "slack_webhook_secret_version" {
  secret_id     = aws_secretsmanager_secret.slack_webhook_secret.id
  secret_string = "{\"webhook\": \"test\"}" # ${var.slack_webhook} would go here.
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

  bucket = "ssh-brute-force-response-auth-bucket-1251231"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}
*/