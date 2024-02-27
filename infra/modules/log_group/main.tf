resource "aws_kms_key" "symetric" {
  count               = var.encrypt ? 1 : 0
  description         = "KMS key to encrypt and decrypt logs from ${var.name}"
  key_usage           = "ENCRYPT_DECRYPT"
  enable_key_rotation = true
  policy              = var.kms_policy
}

resource "aws_cloudwatch_log_group" "main" {
  # encryption is optional depending on the needs
  #checkov:skip=CKV_AWS_158: "Ensure that CloudWatch Log Group is encrypted by KMS"
  name              = var.name
  retention_in_days = var.logs_retention_days
  kms_key_id        = var.encrypt ? aws_kms_key.symetric.0.key_id : null
}
