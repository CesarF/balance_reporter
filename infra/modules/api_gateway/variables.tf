variable "api_gw_name" {
  type = string
}

variable "api_gw_stage" {
  description = "Name of the api gateway stage."
  type        = string
}

variable "lambda_invoke_arn" {
  description = "This is lambda output arn"
  type        = string
}

variable "lambda_function_name" {
  type = string
}
