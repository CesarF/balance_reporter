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

variable "name" {
  description = "Name of the api gateway"
  type        = string
}

variable "open_api_specification" {
  description = "Json document that describes the API"
  type        = string
}

variable "apigateway_stage" {
  description = "Name of the api gateway stage."
  type        = string
}

variable "log_level" {
  description = "General log level for all endpoints. This can be overwritten by additional_settings"
  type        = string
}

variable "additional_settings" {
  description = "List of additional settings for each enpoint. It supports method and log_level for now"
  type = list(object({
    method    = string
    log_level = string
  }))
  default = []
}

variable "apigateway_main_role" {
  description = "Name of the API gateway main role. This role is used for logging."
  type        = string
}

variable "log_retention_days" {
  description = "Number of days logs are retained. 30 days by default"
  type        = number
  default     = 30
}

variable "endpoint_configuration_types" {
  description = "List of endpoint types. Currently only supports managing a single value."
  type        = list(string)
  default     = ["REGIONAL"]
}

variable "vpc_endpoint_ids" {
  description = "List of vpc endpoints required if the endpoint configuration type is PRIVATE."
  type        = list(string)
  nullable    = false
  default     = []
}

variable "api_gateway_policy" {
  description = "Policy document for API GW. It is required if the configuration is PRIVATE."
  type        = any
  default     = null
  nullable    = true
}

variable "stage_variables" {
  description = "String map that contains all stage variables"
  type        = map(string)
  default     = null
  nullable    = true
}

variable "enable_tracing" {
  description = "Enable X-Ray to get the X-Amzn-Trace-Id header"
  type        = bool
  default     = false
}
