variable "bucket_name" {
  type = string
}

variable "public_access" {
  type    = bool
  default = true
}

variable "enable_versioning" {
  type    = bool
  default = false
}
