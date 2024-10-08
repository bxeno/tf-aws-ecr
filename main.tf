resource "aws_ecr_repository" "repo" {
  name = join("-",
    compact(
      [
        module.context.platform,
        module.context.service,
        var.name
      ]
    )
  )

  force_delete = var.force_delete

  image_scanning_configuration {
    scan_on_push = var.image_scanning #tfsec:ignore:AWS023
  }

  tags = module.context.tags
}

resource "aws_ecr_repository_policy" "repo" {
  count = sum(
    [
      length(var.read_aws_principals),
      length(var.read_service_principals),
      length(var.write_aws_principals),
      length(var.write_service_principals)
  ]) > 0 ? 1 : 0
  repository = aws_ecr_repository.repo.name
  policy     = data.aws_iam_policy_document.repo.json
}

resource "aws_ecr_lifecycle_policy" "repo" {
  repository = aws_ecr_repository.repo.name
  policy = coalesce(
    try(jsondecode(var.custom_lifecycle_policy_document), var.custom_lifecycle_policy_document),
    data.aws_ecr_lifecycle_policy_document.default_lifecycle_policy.json
  )
}
