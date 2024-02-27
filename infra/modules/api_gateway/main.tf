resource "aws_api_gateway_rest_api" "main" {
  name        = var.api_gw_name
  description = "Used for personal purposes"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_iam_role" "main" {
  name        = "apigateway_logging"
  path        = "/apigateway/${terraform.workspace}/"
  description = "Allows logs to ship to cloudwatch for basic logging."

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "logging" {
  role       = aws_iam_role.main.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}


resource "aws_api_gateway_method" "root" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_rest_api.main.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
  depends_on = [
    aws_api_gateway_rest_api.main
  ]
}

resource "aws_api_gateway_integration" "root_integration" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_method.root.resource_id
  http_method = aws_api_gateway_method.root.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
  depends_on = [
    aws_api_gateway_rest_api.main
  ]
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "{proxy+}"
  depends_on = [
    aws_api_gateway_rest_api.main
  ]
}

resource "aws_api_gateway_method" "proxy" {
  depends_on = [
    aws_api_gateway_resource.proxy,
    aws_api_gateway_rest_api.main
  ]
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "proxy" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_method.proxy.resource_id
  http_method             = aws_api_gateway_method.proxy.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
  depends_on = [
    aws_api_gateway_method.proxy,
  ]
}

resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    aws_api_gateway_integration.proxy
  ]
}

resource "aws_api_gateway_method_settings" "throttle_settings" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = aws_api_gateway_stage.main.stage_name

  method_path = "*/*"

  # We can replace this harcoded values as a variables
  settings {
    throttling_burst_limit = 1
    throttling_rate_limit  = 5
    logging_level          = "ERROR"
  }

  depends_on = [
    aws_api_gateway_deployment.main
  ]
}

resource "aws_cloudwatch_log_group" "access_logs" {
  name              = "/aws/apigateway/access_logs/${terraform.workspace}/${aws_api_gateway_rest_api.main.name}_${aws_api_gateway_rest_api.main.id}"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "execution_logs" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.main.id}/${var.api_gw_stage}"
  retention_in_days = 30
}

resource "aws_api_gateway_stage" "main" {
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id   = aws_api_gateway_rest_api.main.id
  stage_name    = var.api_gw_stage

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.access_logs.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      sourceIp       = "$context.identity.sourceIp"
      requestTime    = "$context.requestTime"
      user           = "$context.authorizer.claims.username"
      authorizer     = "$context.identity.cognitoIdentityPoolId"
      protocol       = "$context.protocol"
      httpMethod     = "$context.httpMethod"
      resourcePath   = "$context.resourcePath"
      routeKey       = "$context.routeKey"
      status         = "$context.status"
      responseLength = "$context.responseLength"
      integration = {
        latency = "$context.integration.latency"
        error   = "$context.integration.error"
        status  = "$context.integration.status"
      }
    })
  }
}

resource "aws_lambda_permission" "invoke" {
  statement_id  = "${var.api_gw_name}-allow-api-invoke-${var.lambda_function_name}"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.main.execution_arn}/*/*/*"
}
