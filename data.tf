data "aws_caller_identity" "current" {}
data "aws_region" "current" {}


data "aws_iam_policy_document" "repo" {
  dynamic "statement" {
    for_each = length(var.read_aws_principals) > 0 ? [1] : []
    content {
      sid = "ReadAWSPrincipals"

      actions = [
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:ListImages"
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
        "ecr:ListImages"
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

data "aws_ecr_lifecycle_policy_document" "default_lifecycle_policy" {
  rule {
    priority    = 1
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

  rule {
    priority    = 2
    description = "Keep only ${var.lifecycle_images_to_keep} images"

    selection {
      tag_status   = "any"
      count_type   = "imageCountMoreThan"
      count_number = var.lifecycle_images_to_keep
    }

    action {
      type = "expire"
    }
  }
}
