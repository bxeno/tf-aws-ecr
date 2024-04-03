locals {
  name = coalesce(var.name, var.service)

  default_lifecycle_policy = <<EOF
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

  lifecycle_policy = coalesce(var.custom_lifecycle_policy_document, local.default_lifecycle_policy)
}
