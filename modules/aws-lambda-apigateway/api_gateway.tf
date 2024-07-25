data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_api_gateway_rest_api" "ip-plz" {
  name        = "ip-plz-${var.env}"
  description = "API Gateway for ip-plz Lambda function"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_resource" "ip-plz" {
  rest_api_id = aws_api_gateway_rest_api.ip-plz.id
  parent_id   = aws_api_gateway_rest_api.ip-plz.root_resource_id
  path_part   = "ip"
}

resource "aws_api_gateway_method" "ip-plz" {
  #checkov:skip=CKV_AWS_59:Not needed
  #checkov:skip=CKV2_AWS_53:Not needed
  rest_api_id        = aws_api_gateway_rest_api.ip-plz.id
  resource_id        = aws_api_gateway_resource.ip-plz.id
  http_method        = "GET"
  authorization      = "NONE"
  request_parameters = { "method.request.header.X-Forwarded-For" = false }
}

resource "aws_api_gateway_method_settings" "path_specific" {
  #checkov:skip=CKV_AWS_308:Not needed
  #checkov:skip=CKV_AWS_225:Not needed
  rest_api_id = aws_api_gateway_rest_api.ip-plz.id
  stage_name  = aws_api_gateway_stage.ip-plz_v1.stage_name
  method_path = "*/*"

  settings {
    caching_enabled        = false
    logging_level          = "OFF"
    throttling_rate_limit  = 1
    throttling_burst_limit = 5
  }
}

resource "aws_api_gateway_integration" "ip-plz" {
  rest_api_id             = aws_api_gateway_rest_api.ip-plz.id
  resource_id             = aws_api_gateway_resource.ip-plz.id
  http_method             = aws_api_gateway_method.ip-plz.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
  timeout_milliseconds    = 5000
}

resource "aws_api_gateway_deployment" "ip-plz_v1" {
  #checkov:skip=CKV_AWS_217:Not needed
  depends_on = [
    aws_api_gateway_integration.ip-plz,
    aws_api_gateway_method.ip-plz
  ]
  rest_api_id = aws_api_gateway_rest_api.ip-plz.id
}

resource "aws_api_gateway_stage" "ip-plz_v1" {
  #checkov:skip=CKV_AWS_76:No logs needed
  #checkov:skip=CKV_AWS_73:Not needed
  #checkov:skip=CKV_AWS_120:Not needed
  #checkov:skip=CKV2_AWS_4:Not needed
  #checkov:skip=CKV2_AWS_51:Not needed
  #checkov:skip=CKV2_AWS_29:Not needed
  depends_on = [
    aws_api_gateway_integration.ip-plz,
    aws_api_gateway_method.ip-plz
  ]
  deployment_id = aws_api_gateway_deployment.ip-plz_v1.id
  rest_api_id   = aws_api_gateway_rest_api.ip-plz.id
  stage_name    = "v1"
}

resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.ip-plz.id}/*/${aws_api_gateway_method.ip-plz.http_method}${aws_api_gateway_resource.ip-plz.path}"
}
