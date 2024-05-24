data "aws_iam_policy_document" "ro_access" {
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

data "aws_iam_policy_document" "combined" {
  source_policy_documents = concat(
    var.ro_for_higher_environments ? [data.aws_iam_policy_document.ro_access.json] : [],
    var.lambda_accessible ? [data.aws_iam_policy_document.lambda_access.json] : []
  )
}
