variable "is_mutable" {
  description = "Set true to enable mutability in all the repositories."
  type        = bool
  default     = true
}

variable "repository_name" {
  description = "Name of the registry"
  type        = string
  default     = "balance-processor"
}
