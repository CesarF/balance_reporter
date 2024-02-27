data "aws_ecr_image" "source" {
  repository_name = var.repository_name
  image_tag       = var.image_version
}

data "aws_ecr_repository" "image_repository" {
  name = var.repository_name
}

# Least privilege principle, limit access to cloudwatch log groups.
# Basic permissions required for the lambda
data "aws_iam_policy_document" "basic_permissions" {
  #checkov:skip=CKV_AWS_111: "Ensure IAM policies does not allow write access without constraints"
  #checkov:skip=CKV_AWS_356: "Ensure IAM policies limit resource access"
  statement {
    sid = "LambdaLogsCreatePutLogsPolicy"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect = "Allow"
    # Wildcard is required to create log events and log streams in the log group.
    #tfsec:ignore:aws-iam-no-policy-wildcards
    resources = ["${module.lambda_log.log_arn}:*"]
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

  statement {
    sid    = "LambdaNetworkPolicy"
    effect = "Allow"
    actions = [
      "ec2:DescribeNetworkInterfaces",
      "ec2:CreateNetworkInterface",
      "ec2:DeleteNetworkInterface",
      "ec2:AttachNetworkInterface"
    ]
    # This permission is required to move the lambda into a vpc.
    #tfsec:ignore:aws-iam-no-policy-wildcards
    resources = ["*"]
  }
}

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["vpc-main-${var.metadata.stage}"]
  }
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
  filter {
    name   = "tag:Type"
    values = ["Private"]
  }
}
