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

variable "bucket_name" {
  description = "Bucket name. In case of websites it will be the url prefix."
  type        = string
}

variable "public_access" {
  description = "If this variable is true, public read acl will be granted. By default false"
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "If this variable is true, object versioning will be enabled. By default true"
  type        = bool
  default     = true
}
