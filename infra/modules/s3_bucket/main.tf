resource "aws_s3_bucket" "main" {
  bucket        = "${var.metadata.product}-${var.bucket_name}"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "main" {
  bucket = aws_s3_bucket.main.id
  acl    = var.public_access ? "public-read" : "private"
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = !var.public_access
  block_public_policy     = !var.public_access
  ignore_public_acls      = !var.public_access
  restrict_public_buckets = !var.public_access
}

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Disabled"
  }
}
