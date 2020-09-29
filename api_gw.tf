// TODO:
// Protocol - http or websocket
// CORS     - configuration
// Authorizers for OAuth authorization
resource "aws_apigatewayv2_api" "function" {
  name          = local.name
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.function.id
  auto_deploy = true
  name        = "$default"
}

resource "aws_apigatewayv2_route" "default" {
  api_id    = aws_apigatewayv2_api.function.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.function.id}"
}

resource "aws_apigatewayv2_integration" "function" {
  api_id                 = aws_apigatewayv2_api.function.id
  integration_type       = "AWS_PROXY"
  description            = local.name
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.function.invoke_arn
  payload_format_version = "1.0"
}
