resource "aws_api_gateway_rest_api" "main" {
  # This is already covered in the deployment
  #checkov:skip=CKV_AWS_237: "Ensure Create before destroy for API GATEWAY"
  name        = "${var.metadata.product}-${var.name}"
  description = "Api gateway for ${var.metadata.product}"
  body        = var.open_api_specification

  endpoint_configuration {
    # Since all api gateways will be deployed in same region for now
    # this is the recommended configuration
    # https://docs.aws.amazon.com/apigateway/latest/developerguide/create-regional-api.html
    types            = var.endpoint_configuration_types
    vpc_endpoint_ids = contains(var.endpoint_configuration_types, "PRIVATE") ? toset(var.vpc_endpoint_ids) : null
  }

  lifecycle { prevent_destroy = true }
}

resource "aws_api_gateway_rest_api_policy" "api_policy" {
  count       = contains(var.endpoint_configuration_types, "PRIVATE") ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.main.id
  policy      = var.api_gateway_policy
}

resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id

  # We need to redeploy the api gateway if the vpc endpoints or configuration is modified.
  # that is the reason we are configuring this to trigger the deployment if any value changes.
  triggers = {
    redeployment = sha1(jsonencode([
      var.vpc_endpoint_ids,
      var.endpoint_configuration_types,
      var.api_gateway_policy,
      aws_api_gateway_rest_api.main.body
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_rest_api_policy.api_policy
  ]
}

resource "aws_api_gateway_account" "logging" {
  cloudwatch_role_arn = data.aws_iam_role.general.arn

  depends_on = [
    aws_api_gateway_rest_api.main
  ]
}

module "api_access_logs" {
  source              = "../log_group"
  name                = "${var.metadata.product}/${var.metadata.stage}/apigateway/access_logs/${aws_api_gateway_rest_api.main.name}_${aws_api_gateway_rest_api.main.id}/"
  logs_retention_days = var.log_retention_days
  encrypt             = false
}

# Declaring log group here we can restrict the retention period of logs,
# This name is defined by AWS, it can not be modified, we are just overriding the module
# to change the retention in days
module "api_execution_logs" {
  source              = "../log_group"
  name                = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.main.id}/${var.apigateway_stage}"
  logs_retention_days = var.log_retention_days
  encrypt             = false
}

# TBD are we going to use X-RAY tracing?
#tfsec:ignore:aws-api-gateway-enable-tracing
resource "aws_api_gateway_stage" "main" {
  # Already covered in aws_api_gateway_method_settings
  #checkov:skip=CKV2_AWS_4: "Ensure API Gateway stage have logging level defined as appropriate"
  #checkov:skip=CKV_AWS_73: "Ensure API Gateway has X-Ray Tracing enabled"
  # TODO check this configuration in case we need a public API
  #checkov:skip=CKV2_AWS_29: "Ensure public API gateway are protected by WAF"
  # TODO check certificate authentication
  #checkov:skip=CKV2_AWS_51: "Ensure AWS API Gateway endpoints uses client certificate authentication"
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id   = aws_api_gateway_rest_api.main.id
  stage_name    = var.apigateway_stage
  # TODO add cache in next versions
  #checkov:skip=CKV_AWS_120: "Ensure API Gateway caching is enabled"
  cache_cluster_enabled = false
  cache_cluster_size    = "0.5"

  variables = var.stage_variables

  access_log_settings {
    destination_arn = module.api_access_logs.log_arn
    # Base on REserve configuration
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

#tfsec:ignore:aws-api-gateway-enable-cache
resource "aws_api_gateway_method_settings" "all" {
  #checkov:skip=CKV_AWS_225: "Ensure API Gateway method setting caching is enabled"
  #checkov:skip=CKV_AWS_276: "Ensure Data Trace is not enabled in API Gateway Method Settings"
  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = aws_api_gateway_stage.main.stage_name
  method_path = "*/*"

  settings {
    # Enable CloudWatch logging and metrics
    metrics_enabled      = true
    data_trace_enabled   = var.enable_tracing
    caching_enabled      = false
    cache_data_encrypted = true
    logging_level        = var.log_level
  }
}

#tfsec:ignore:aws-api-gateway-enable-cache
resource "aws_api_gateway_method_settings" "specific" {
  #checkov:skip=CKV_AWS_225: "Ensure API Gateway method setting caching is enabled"
  #checkov:skip=CKV_AWS_276: "Ensure Data Trace is not enabled in API Gateway Method Settings"
  for_each    = { for setting in var.additional_settings : setting.method => setting }
  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = aws_api_gateway_stage.main.stage_name
  method_path = each.key

  settings {
    # Enable CloudWatch logging and metrics
    metrics_enabled      = true
    data_trace_enabled   = var.enable_tracing
    caching_enabled      = false
    cache_data_encrypted = true
    logging_level        = var.log_level
  }
}
