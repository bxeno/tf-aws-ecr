locals {
  module_context = {
    platform    = var.platform
    environment = var.environment
    service     = var.service
    region      = var.region
    deployment  = var.deployment

    element_delimiter = "-"
    element_order     = ["environment", "deployment", "platform", "service"]
    required_elements = ["environment", "deployment", "service"]

    tags = null

    stack            = null
    short_stack      = null
    ssm_stack        = null
    full_environment = null
    full_service     = null
  }
}

module "context" {
  source  = "app.terraform.io/fatzebra/context/null"
  version = "0.0.1"
  context = local.module_context
}
