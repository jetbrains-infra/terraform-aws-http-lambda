# Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${local.region}:${local.account_id}:${aws_apigatewayv2_api.function.id}/*/${aws_apigatewayv2_route.default.route_key}"
}

resource "aws_lambda_function" "function" {
  filename         = local.lambda_archive
  function_name    = local.name
  role             = aws_iam_role.role.arn
  handler          = local.handler
  runtime          = local.runtime
  source_code_hash = filebase64sha256(local.lambda_archive)
  memory_size      = local.memory_size
  timeout          = local.timeout

  environment {
    variables = local.envvars
  }
}
