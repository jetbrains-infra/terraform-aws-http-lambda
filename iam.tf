data "aws_iam_policy_document" "function_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "role" {
  name               = local.name
  assume_role_policy = data.aws_iam_policy_document.function_role.json
}

data aws_iam_policy_document "logs" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "LambdaLogging${local.name}"
  path        = "/"
  description = "IAM policy for logging from ${local.name} lambda."
  policy      = data.aws_iam_policy_document.logs.json
}

resource "aws_iam_role_policy_attachment" "logging" {
  policy_arn = aws_iam_policy.lambda_logging.arn
  role       = aws_iam_role.role.name
}
