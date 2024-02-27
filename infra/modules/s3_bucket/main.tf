# TODO add optional configuration to encript documents
# TODO check benefits to enable logging
# public read is required to deploy public web pages
#tfsec:ignore:aws-s3-specify-public-access-block
#tfsec:ignore:aws-s3-encryption-customer-key
#tfsec:ignore:aws-s3-enable-bucket-logging
#tfsec:ignore:aws-s3-no-public-buckets
#tfsec:ignore:aws-s3-ignore-public-acls
#tfsec:ignore:aws-s3-enable-bucket-encryption
#tfsec:ignore:aws-s3-block-public-policy
#tfsec:ignore:aws-s3-block-public-acls
resource "aws_s3_bucket" "main" {
  # Notification enabled is not required for now.
  #checkov:skip=CKV2_AWS_62: "Ensure S3 buckets should have event notifications enabled"
  # We are not using lifecycle configuration in our buckets. We don't require it for now.
  #checkov:skip=CKV2_AWS_61: "Ensure that an S3 bucket has a lifecycle configuration"
  #checkov:skip=CKV2_AWS_6: "Ensure that S3 bucket has a Public Access block"
  #checkov:skip=CKV_AWS_18: "Ensure the S3 bucket has access logging enabled"
  #checkov:skip=CKV_AWS_19: "Ensure all data stored in the S3 bucket is securely encrypted at rest"
  #checkov:skip=CKV_AWS_144: "Ensure that S3 bucket has cross-region replication enabled"
  #checkov:skip=CKV_AWS_145: "Ensure that S3 buckets are encrypted with KMS by default"
  #checkov:skip=CKV_AWS_20: "S3 Bucket has an ACL defined which allows public READ access."
  #checkov:skip=CKV_AWS_21: "Ensure all data stored in the S3 bucket have versioning enabled"
  bucket        = "${var.metadata.product}-${var.bucket_name}"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "main" {
  bucket = aws_s3_bucket.main.id
  acl    = var.public_access ? "public-read" : "private"
}

resource "aws_s3_bucket_public_access_block" "main" {
  #checkov:skip=CKV_AWS_53: "Ensure S3 bucket has block public ACLS enabled"
  #checkov:skip=CKV_AWS_54: "Ensure S3 bucket has block public policy enabled"
  #checkov:skip=CKV_AWS_55: "Ensure S3 bucket has ignore public ACLs enabled"
  #checkov:skip=CKV_AWS_56: "Ensure S3 bucket has 'restrict_public_bucket' enabled"
  bucket = aws_s3_bucket.main.id

  block_public_acls       = !var.public_access
  block_public_policy     = !var.public_access
  ignore_public_acls      = !var.public_access
  restrict_public_buckets = !var.public_access
}

# Not all objects require versioning available
#tfsec:ignore:aws-s3-enable-versioning
resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Disabled"
  }
}
