variable "image_version" {
  description = "ecr image version. Use the pyproject.toml version"
  type        = string
  default     = "0.1.0"
}

variable "service" {
  type    = string
  default = "balance-processor"
}
