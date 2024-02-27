data "aws_ecr_image" "source" {
  repository_name = var.registry
  image_tag       = var.image_version
}

data "aws_ecr_repository" "image_repository" {
  name = var.registry
}

data "aws_iam_policy_document" "basic_permissions" {
  statement {
    sid = "LambdaLogsCreatePutLogsPolicy"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect    = "Allow"
    resources = ["${aws_cloudwatch_log_group.main.arn}:*"]
  }

  statement {
    sid = "LambdaECRImageCrossAccountRetrievalPolicy"
    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
    effect    = "Allow"
    resources = [data.aws_ecr_repository.image_repository.arn]
  }

  # TODO remove wildcards, this is not a good practice
  statement {
    sid = "LambdaAccessS3"
    actions = [
      "s3:*"
    ]
    effect    = "Allow"
    resources = ["arn:aws:s3:::*"]
  }

  # TODO remove wildcards, this is not a good practice
  statement {
    sid = "LambdaAccessDynamoRO"
    actions = [
      "dynamodb:ListContributorInsights",
      "dynamodb:DescribeReservedCapacityOfferings",
      "dynamodb:ListGlobalTables",
      "dynamodb:ListTables",
      "dynamodb:DescribeReservedCapacity",
      "dynamodb:ListBackups",
      "dynamodb:PurchaseReservedCapacityOfferings",
      "dynamodb:ListImports",
      "dynamodb:DescribeLimits",
      "dynamodb:DescribeEndpoints",
      "dynamodb:ListExports",
      "dynamodb:ListStreams"
    ]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    sid = "LambdaAccessDynamo"
    actions = [
      "dynamodb:*"
    ]
    effect    = "Allow"
    resources = ["arn:aws:dynamodb:*:*:table/*"]
  }

  # TODO remove wildcards, this is not a good practice
  statement {
    sid = "LambdaAccessSES"
    actions = [
      "ses:*"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}
