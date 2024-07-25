locals {
  archive_file = var.lambda_archive != "" ? var.lambda_archive : "${path.cwd}/tmp/repo/ip-plz-lambda.zip"
}

resource "aws_lambda_function" "ip-plz" {
  #checkov:skip=CKV_AWS_272:Archive is uploaded, no code-signature verification needed
  #checkov:skip=CKV_AWS_117:Not needed
  #checkov:skip=CKV_AWS_173:Not needed
  #checkov:skip=CKV_AWS_50:Not needed
  #checkov:skip=CKV_AWS_116:Not needed
  function_name = "ip-plz-${var.env}"
  architectures = ["arm64"]
  filename      = local.archive_file
  #source_code_hash = data.local_file.foo.content_base64sha256
  handler                        = "bootstrap"
  role                           = aws_iam_role.ip-plz.arn
  runtime                        = "provided.al2"
  memory_size                    = 128
  timeout                        = 2
  reserved_concurrent_executions = 2

  tags = {
    version = local.version
  }

  environment {
    variables = var.env_vars
  }

  depends_on = [
    time_sleep.wait_60_seconds,
    local_file.checkout_git_repo,
    aws_iam_role_policy_attachment.lambda_logs,
  ]
}

resource "aws_iam_role" "ip-plz" {
  name               = "ip-plz-lambda-${var.env}"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": {
    "Action": "sts:AssumeRole",
    "Principal": {
      "Service": "lambda.amazonaws.com"
    },
    "Effect": "Allow"
  }
}
POLICY
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  #checkov:skip=CKV_AWS_338:Not needed
  #checkov:skip=CKV_AWS_158:Not needed
  name              = "/aws/lambda/ip-plz/${var.env}"
  retention_in_days = 3
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
data "aws_iam_policy_document" "lambda" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      aws_cloudwatch_log_group.lambda_log_group.arn,
      "${aws_cloudwatch_log_group.lambda_log_group.arn}:*"
    ]
  }
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "ip-plz-lambda-logging-${var.env}"
  path        = "/"
  description = "IAM policy for logging from a lambda"
  policy      = data.aws_iam_policy_document.lambda.json
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.ip-plz.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
