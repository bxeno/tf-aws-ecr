resource "aws_ecr_repository" "repo" {
  name = local.name

  image_scanning_configuration {
    scan_on_push = var.image_scanning #tfsec:ignore:AWS023
  }
}

resource "aws_ecr_repository_policy" "repository_policy" {
  repository = aws_ecr_repository.repo.name
  policy     = data.aws_iam_policy_document.combined.json
}

resource "aws_ecr_lifecycle_policy" "repo" {
  repository = aws_ecr_repository.repo.name
  policy     = local.lifecycle_policy
}
