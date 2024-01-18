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
}

variable "repo_principals_ro" {
  type    = list(any)
  default = []
}

variable "lambda_accessible" {
  type    = bool
  default = false
}

variable "ro_for_higher_environments" {
  type    = bool
  default = true
}

variable "lifecycle_images_to_keep" {
  type    = number
  default = 4
}

variable "image_scanning" {
  type    = bool
  default = true
}
