resource "aws_iam_user" "ecr-user" {
  name = "ecr-user"
  path = "/system/"
  tags = {
    Environment = "${var.environment}"
    Service     = "${var.service}"
  }
}

resource "aws_iam_user_policy" "ecr-user-policy" {
  name = "ecr-user-policy"
  user = aws_iam_user.ecr-user.name

  # AWS profile 계정에 생성되어 있는 모든 ECR 리소스에 ecr 관련 모든 액션을 수행할 권한이 있음.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_access_key" "ecr-user-access-key" {
  user = aws_iam_user.ecr-user.name
}
