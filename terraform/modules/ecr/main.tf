provider "aws" {
  region = "us-east-1"
}

# ====================================================================
# 1. Create ECR Repository - Users Service - Orders Service - Products Service - 
# ====================================================================

resource "aws_ecr_repository" "this" {

  for_each = toset(var.repository_names)

  name                 = "${var.environment}-${each.value}"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name        = "${var.environment}-${each.value}"
    environment = "${var.environment}"
  }
}

resource "aws_ecr_lifecycle_policy" "this" {

  for_each = toset(var.repository_names)

  repository = aws_ecr_repository.this[each.key].name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "keep only 10 latest images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["${var.environment}"]
          countType     = "imageCountMoreThan"
          countNumber   = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
