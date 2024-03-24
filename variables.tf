variable "platform" {
  description = "Platform name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "service" {
  description = "Service name"
  type        = string
}

variable "region" {
  description = "Region name"
  type        = string
}

variable "deployment" {
  description = "Deployment name"
  type        = string
  default     = ""
  nullable    = false
}

variable "name" {
  type    = string
  default = ""
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

variable "create_ecr_repository" {
  type     = bool
  default  = false
  nullable = false
}
