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
