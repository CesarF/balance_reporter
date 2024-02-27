locals {
  # Variables required by the lambda
  environment = {
    FILE_PATH       = "${module.bucket.bucket_name}/${var.file_name}"
    EMAIL_SENDER    = var.email_sender
    EMAIL_RECIPIENT = var.email_recipient
    DYNAMO_TABLE    = module.table.table_name
    LOG_LEVEL       = "DEBUG"
  }
}
