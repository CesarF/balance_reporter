resource "aws_iam_role" "main" {
  name        = var.function_name
  path        = "/lambda/${terraform.workspace}/"
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

resource "aws_cloudwatch_log_group" "main" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 30
}

resource "aws_iam_role_policy" "default" {
  name_prefix = "${var.function_name}__default--"
  role        = aws_iam_role.main.id
  policy      = data.aws_iam_policy_document.basic_permissions.json
}

resource "aws_lambda_function" "main" {
  function_name = var.function_name
  role          = aws_iam_role.main.arn
  package_type  = "Image"
  image_uri     = "${data.aws_ecr_repository.image_repository.repository_url}@${data.aws_ecr_image.source.image_digest}"
  architectures = ["x86_64"]
  timeout       = 10

  environment {
    variables = var.env_variables
  }

  depends_on = [aws_iam_role_policy.default]
}
