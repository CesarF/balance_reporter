locals {
  # Variables required by the lambda
  environment = {
    FILE_PATH          = "${module.bucket.bucket_domain_name}/${var.file_name}"
    EMAIL_SENDER       = var.email_sender
    EMAIL_RECIPIENT    = var.email_recipient
    LOG_LEVEL          = "DEBUG"
  }
}
