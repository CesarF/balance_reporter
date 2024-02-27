########################################
# Mandatory variables
########################################

variable "metadata" {
  description = "Metadata map to configure components. Includes product and stage."
  type        = map(string)
  nullable    = false

  validation {
    condition     = contains(keys(var.metadata), "product") && contains(keys(var.metadata), "stage")
    error_message = "Map must constains 'product' and 'stage'."
  }
}

########################################
# Module variables
########################################

variable "function_name" {
  description = "Lambda function name"
  type        = string
}

variable "image_version" {
  description = "major.minor.patch version of the image"
  type        = string
  nullable    = false
}

variable "repository_name" {
  description = "Name of the repository in the ECR service. This repository must be in the same account"
  type        = string
  nullable    = false
}

variable "logs_retention_days" {
  description = "Number of days that logs will be retained. After that time, logs will be deleted. 30 days by default."
  type        = number
  default     = 30
}

variable "function_architecture" {
  description = "Type of computer processor that Lambda uses to run the function. x86_64 by default"
  type        = string
  default     = "x86_64"
}

variable "env_variables" {
  description = "Map object with environment variables required by function. Empty by default."
  type        = map(string)
  default     = null
}

variable "execution_timeout" {
  # Check https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html
  description = "Maximum execution time in seconds. If this time is reached request is finished. Default 5 seconds."
  type        = number
  default     = 5
}

variable "vpc_access" {
  description = "Describes if the vpc must be configured in the lambda or not"
  type        = bool
  default     = false
}

variable "enable_tracing" {
  description = "Enable X-Ray to get the X-Amzn-Trace-Id header"
  type        = bool
  default     = false
}
