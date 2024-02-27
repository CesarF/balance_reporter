# TODO Add multiple custom security groups
module "security_group" {
  source              = "../net"
  count               = var.vpc_access ? 1 : 0
  metadata            = var.metadata
  name_prefix         = "${local.function_name}__lambda--"
  vpc_id              = data.aws_vpc.main.id
  ingress_description = "Inbound rule for ${local.function_name}"
  egress_description  = "Outbound rule for ${local.function_name}"
}

resource "aws_iam_role" "main" {
  name        = local.function_name
  path        = "/${var.metadata.product}/${var.metadata.stage}/lambda/"
  description = "Allows Lambda Function to call AWS services on your behalf."
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "LambdaAssume"
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Log name is defined by AWS, it can not be modified, we are just overriding the log group
# to update the retention days
module "lambda_log" {
  source              = "../log_group"
  name                = "/aws/lambda/${local.function_name}"
  logs_retention_days = var.logs_retention_days
  encrypt             = false
}

resource "aws_iam_role_policy" "default" {
  name_prefix = "${local.function_name}__default--"
  role        = aws_iam_role.main.id
  policy      = data.aws_iam_policy_document.basic_permissions.json
}

resource "aws_lambda_function" "main" {
  # Put lambda inside a VPC is optional
  #checkov:skip=CKV_AWS_117:Ensure that AWS Lambda function is configured inside a VPC
  # DLQ is not required for now, use cloudwatch logs for monitoring
  #checkov:skip=CKV_AWS_116:Ensure that AWS Lambda function is configured for a Dead Letter Queue(DLQ)
  #checkov:skip=CKV_AWS_272:Ensure AWS Lambda function is configured to validate code-signing
  # Skip this rule for now, validate limit after deployment
  #checkov:skip=CKV_AWS_115:Ensure that AWS Lambda function is configured for function-level concurrent execution limit
  function_name = local.function_name
  role          = aws_iam_role.main.arn
  package_type  = "Image"
  image_uri     = "${data.aws_ecr_repository.image_repository.repository_url}@${data.aws_ecr_image.source.image_digest}"
  architectures = [var.function_architecture]
  timeout       = var.execution_timeout

  # Disable the X-Ray tracing for lambdas
  #tfsec:ignore:aws-lambda-enable-tracing
  tracing_config {
    mode = var.enable_tracing == true ? "Active" : "PassThrough"
  }

  # TODO validate kms implementation for lambdas
  #checkov:skip=CKV_AWS_173:Check encryption settings for Lambda environmental variable
  dynamic "environment" {
    for_each = var.env_variables != null ? [true] : []
    content {
      variables = var.env_variables
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_access ? [true] : []
    content {
      subnet_ids         = data.aws_subnets.subnets.ids
      security_group_ids = [module.security_group.0.security_group_id]
    }
  }

  depends_on = [aws_iam_role_policy.default]
}
