variable "context" {
  description = "The context to use for forming names and tags"
  type = object(
    {
      platform          = string
      environment       = string
      service           = string
      deployment        = string
      element_delimiter = optional(string)
      element_order     = optional(list(string))
      required_elements = optional(list(string))
      tags              = map(string)
      stack             = string
      short_stack       = string
      ssm_stack         = string
      full_environment  = string
      full_service      = string
    }
  )
}

variable "name" {
  description = "A suffix to append to the context to build a name"
  type        = string
  default     = ""
}

variable "name_override" {
  description = "A name to set as the full image name. Overrides the context setup"
  type        = string
  default     = ""
}

variable "force_delete" {
  description = "Remove the images before deleting the repository"
  type        = bool
  default     = true
}

variable "allowed_organisation_ids" {
  description = "AWS organisation filter applied to all principals on the read only policy"
  type        = list(string)
  default = [
    "o-cj474haxbs", # accounts@fatzebra.com.au - Management Account: 871500768402
    "o-i01x90y5fw", # engineering+master@adatree.com.au - Management Account: 741634499280
  ]
}

# NOTE: if you remove the organisations rule then make sure you set a principal
variable "read_aws_principals" {
  description = "A list of AWS Principals (generally account roots) that can have read only access"
  type        = list(string)
  default = [
    "arn:aws:iam::748746525051:root", # FZ Test
    "arn:aws:iam::775691310813:root", # FZ Sandbox
    "arn:aws:iam::393255818646:root", # FZ Prod
    "arn:aws:iam::840853425342:root", # FZ Interconnet
  ]
}

variable "read_service_principals" {
  description = "A list of AWS service principals ( service host naames ) that are given read only access"
  type        = list(string)
  default = [
    "lambda.amazonaws.com"
  ]
}

variable "write_aws_principals" {
  description = "A list of AWS Principals (generally account roots) that can have read write access"
  type        = list(string)
  default = [
    "arn:aws:iam::748746525051:root", # FZ Test
  ]
}

variable "write_service_principals" {
  description = "A list of AWS service principals ( service host names ) that can have write access access"
  type        = list(string)
  default     = []
}

variable "image_scanning" {
  description = "Enable image scanning on push"
  type        = bool
  default     = true
}

variable "locked_tags" {
  description = "A list of tags that can't be expired"
  type        = list(string)
  default     = ["latest", "stable", "edge", "prod", "sbox", "test", "staging"]
}

variable "custom_lifecycle_policy_document" {
  description = "A json document with a custom lifecycle policy to use instead of a default one"
  type        = any
  default     = ""

  validation {
    error_message = "Policy document must either be a json string or an object"
    condition     = can(jsondecode(var.custom_lifecycle_policy_document)) || can(jsonencode(var.custom_lifecycle_policy_document))
  }
}
