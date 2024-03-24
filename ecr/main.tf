resource "aws_ecr_repository" "repo" {
  name = local.name

  image_scanning_configuration {
    scan_on_push = var.image_scanning #tfsec:ignore:AWS023
  }
}

data "aws_iam_policy_document" "repo" {
  statement {
    sid = "RO for higher environments"
    actions = [
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:ListImages"
    ]
    principals {
      type        = "AWS"
      identifiers = var.repo_principals_ro
    }
  }
}

resource "aws_ecr_repository_policy" "repo" {
  count = var.ro_for_higher_environments ? 1 : 0

  repository = aws_ecr_repository.repo.name
  policy     = data.aws_iam_policy_document.repo.json
}

resource "aws_ecr_lifecycle_policy" "repo" {
  repository = aws_ecr_repository.repo.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Remove untagged images",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 1
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 2,
            "description": "Keep only ${var.lifecycle_images_to_keep} images",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": ${var.lifecycle_images_to_keep}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

data "aws_iam_policy_document" "lambda_access" {
  statement {
    sid    = "LambdaECRImageRetrievalPolicy"
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_ecr_repository_policy" "lambda_access" {
  count = var.lambda_accessible ? 1 : 0

  repository = aws_ecr_repository.repo.name
  policy     = data.aws_iam_policy_document.lambda_access.json
}
