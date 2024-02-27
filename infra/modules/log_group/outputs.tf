output "log_arn" {
  value = aws_cloudwatch_log_group.main.arn
}

output "log_name" {
  value = aws_cloudwatch_log_group.main.name
}

output "kms_id" {
  description = "kms id, if encryption is not enable value is null"
  value       = var.encrypt ? aws_cloudwatch_log_group.main.kms_key_id : null
}

output "kms_arn" {
  description = "kms arn, if encryption is not enable value is null"
  value       = var.encrypt ? aws_kms_key.symetric.0.arn : null
}
