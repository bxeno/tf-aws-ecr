variable "service" {
  description = "Service name"
  type        = string
}

variable "repo_principals_ro" {
  type     = list(any)
  default  = []
  nullable = false
}

variable "lambda_accessible" {
  type     = bool
  default  = false
  nullable = false
}

variable "ro_for_higher_environments" {
  type     = bool
  default  = true
  nullable = false
}

variable "lifecycle_images_to_keep" {
  type     = number
  default  = 4
  nullable = false
}

variable "image_scanning" {
  type     = bool
  default  = true
  nullable = false
}

variable "name" {
  type    = string
  default = ""
}

variable "custom_lifecycle_policy_document" {
  type    = string
  default = ""
}
