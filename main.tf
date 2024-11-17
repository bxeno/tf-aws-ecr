resource "aws_ecr_repository" "repo" {
  name = join("-",
    compact(
      [
        var.context.platform,
        var.context.service,
        var.name
      ]
    )
  )

  force_delete = var.force_delete

  image_scanning_configuration {
    scan_on_push = var.image_scanning #tfsec:ignore:AWS023
  }

  tags = var.context.tags
}

data "aws_iam_policy_document" "repo" {
  dynamic "statement" {
    for_each = length(var.read_aws_principals) > 0 ? [1] : []
    content {
      sid = "ReadAWSPrincipals"

      actions = [
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:ListImages",
        "ecr:DescribeImages",
        "ecr:DescribeImageScanFindings",
        "ecr:ListTagsForResource",
        "ecr:StartImageScan",
      ]

      principals {
        type        = "AWS"
        identifiers = var.read_aws_principals
      }

      dynamic "condition" {
        for_each = length(var.allowed_organisation_ids) > 0 ? [1] : []
        content {
          variable = "aws:PrincipalOrgID"
          test     = "StringEquals"
          values   = var.allowed_organisation_ids
        }
      }
    }
  }

  dynamic "statement" {
    for_each = length(var.read_service_principals) > 0 ? [1] : []
    content {
      sid = "ReadServicePrincipals"

      actions = [
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:ListImages",
        "ecr:DescribeImages",
        "ecr:DescribeImageScanFindings",
        "ecr:ListTagsForResource",
        "ecr:StartImageScan",
      ]

      principals {
        type        = "Service"
        identifiers = var.read_service_principals
      }

      dynamic "condition" {
        for_each = length(var.allowed_organisation_ids) > 0 ? [1] : []
        content {
          variable = "aws:SourceOrgID"
          test     = "StringEquals"
          values   = var.allowed_organisation_ids
        }
      }
    }
  }

  dynamic "statement" {
    for_each = length(var.write_aws_principals) > 0 ? [1] : []
    content {
      sid = "WriteAWSPrincipals"

      actions = [
        "ecr:BatchCheckLayerAvailability",
        "ecr:CompleteLayerUpload",
        "ecr:InitiateLayerUpload",
        "ecr:PutImage",
        "ecr:UploadLayerPart",
      ]

      principals {
        type        = "AWS"
        identifiers = var.write_aws_principals
      }

      dynamic "condition" {
        for_each = length(var.allowed_organisation_ids) > 0 ? [1] : []
        content {
          variable = "aws:PrincipalOrgID"
          test     = "StringEquals"
          values   = var.allowed_organisation_ids
        }
      }
    }
  }


  dynamic "statement" {
    for_each = length(var.write_service_principals) > 0 ? [1] : []
    content {
      sid = "WriteServicePrincipals"

      actions = [
        "ecr:BatchCheckLayerAvailability",
        "ecr:CompleteLayerUpload",
        "ecr:InitiateLayerUpload",
        "ecr:PutImage",
        "ecr:UploadLayerPart",
      ]

      principals {
        type        = "Service"
        identifiers = var.write_service_principals
      }

      dynamic "condition" {
        for_each = length(var.allowed_organisation_ids) > 0 ? [1] : []
        content {
          variable = "aws:SourceOrgID"
          test     = "StringEquals"
          values   = var.allowed_organisation_ids
        }
      }
    }
  }
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

data "aws_ecr_lifecycle_policy_document" "default_lifecycle_policy" {
  rule {
    priority    = 999
    description = "Remove untagged images"

    selection {
      tag_status   = "untagged"
      count_type   = "sinceImagePushed"
      count_unit   = "days"
      count_number = 1
    }

    action {
      type = "expire"
    }
  }
}

resource "aws_ecr_lifecycle_policy" "repo" {
  repository = aws_ecr_repository.repo.name
  policy = coalesce(
    try(jsondecode(var.custom_lifecycle_policy_document).json, var.custom_lifecycle_policy_document),
    data.aws_ecr_lifecycle_policy_document.default_lifecycle_policy.json
  )
}
