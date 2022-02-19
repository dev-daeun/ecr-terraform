resource "aws_ecr_repository" "ecr-repo" {
  name = "${var.service}/ecr-with-terraform"
  tags = {
    Environment = "${var.environment}"
    Service     = "${var.service}"
  }
}

resource "aws_ecr_repository_policy" "ecr-policy" {
  repository = aws_ecr_repository.ecr-repo.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ECRRepositoryPolicy",
        Effect = "Deny",
        Principal = {
          AWS = "${aws_iam_user.ecr-user.arn}"
        },
        Action = [
          "ecr:BatchDeleteImage"
        ]
      }
    ]
  })
}

resource "aws_ecr_lifecycle_policy" "ecr-lifecycle-policy" {
  repository = aws_ecr_repository.ecr-repo.name
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Expire images older than 30 days",
        selection = {
          tagStatus   = "any",
          countType   = "sinceImagePushed",
          countUnit   = "days",
          countNumber = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}


resource "aws_ecr_registry_scanning_configuration" "ecr-scan-config" {
  scan_type = "ENHANCED"

  rule {
    scan_frequency = "SCAN_ON_PUSH"
    repository_filter {
      filter      = var.service
      filter_type = "WILDCARD"
    }
  }
}


output "ecr-arn" {
  value = aws_ecr_repository.ecr-repo.arn

}

output "ecr-repo-url" {
  value = aws_ecr_repository.ecr-repo.repository_url
}
