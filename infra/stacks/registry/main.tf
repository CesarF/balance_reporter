resource "aws_ecr_repository" "main" {
  name                 = "${var.repository_name}-${terraform.workspace}"
  image_tag_mutability = var.is_mutable ? "MUTABLE" : "IMMUTABLE"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = true
  }
}
