variable "name" {
  description = "Log group name"
  type        = string
  nullable    = false
}

variable "logs_retention_days" {
  description = "number of days logs will be retained before deletion"
  type        = number
  default     = 7
}

variable "kms_policy" {
  description = "kms policy in json format. Check docs https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html"
  type        = any
  nullable    = true
  default     = null
}

variable "encrypt" {
  description = "enable log encryption"
  type        = bool
  default     = false
}
