module "ecr" {
  count = var.create_ecr_repository ? 1 : 0

  source = "./ecr"

  service                    = var.service
  repo_principals_ro         = var.repo_principals_ro
  lambda_accessible          = var.lambda_accessible
  ro_for_higher_environments = var.ro_for_higher_environments
  lifecycle_images_to_keep   = var.lifecycle_images_to_keep
  image_scanning             = var.image_scanning
}
