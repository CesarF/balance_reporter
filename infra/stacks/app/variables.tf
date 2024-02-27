variable "image_version" {
  description = "ecr image version. Use the pyproject.toml version"
  type        = string
  default     = "0.1.0"
}

variable "service" {
  type    = string
  default = "balance-processor"
}

variable "file_name" {
  type    = string
  default = "txns.csv"
}

variable "email_sender" {
  description = "Who will send the email"
  type        = string
  sensitive   = true
}

variable "email_recipient" {
  description = "Who will receive the email"
  type        = string
  sensitive   = true
}
