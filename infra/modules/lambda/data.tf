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
}
