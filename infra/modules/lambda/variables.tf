variable "function_name" {
  description = "Lambda function name"
  type        = string
}

variable "image_version" {
  description = "major.minor.patch version of the image"
  type        = string
  nullable    = false
}

variable "registry" {
  description = "Name of the registry in the ECR service"
  type        = string
  nullable    = false
}

variable "env_variables" {
  description = "Map object with environment variables required by function. Empty by default."
  type        = map(string)
  default     = {}
}
