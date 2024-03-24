locals {
  name = coalesce(var.name, var.service)
}
