provider "aws" {
  region = "us-east-1"
}

# ====================================================================
# 1. OIDC Provider - AWS trusts GitHub as an identity provider
# ====================================================================

data "aws_iam_openid_connect_provider" "github" {
  url  = "https://token.actions.githubusercontent.com"
}

# ====================================================================
# 2. IAM Role - AWS role that GitHub Actions assumes
# ====================================================================

resource "aws_iam_role" "github_actions" {
    name = "github-actions-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = {
                    Federated = data.aws_iam_openid_connect_provider.github.arn
                }
                Action = "sts:AssumeRoleWithWebIdentity"
                Condition = {
                    StringEquals = {
                        "token.actions.githubusercontent.com:sub" = "sts.amazonaws.com"
                    }
                    StringLike = {
                        "token.actions.githubusercontent.com:aud" = "repo:robpalacios1@40041666/aws-devops-terraform-eks:environment:${var.environment}"
                    }
                }
            }
        ]
    })

    tags = {
        Name = "github-actions-role"
        environment = var.environment
    }
}

# ====================================================================
# 3. Permissions - Attach policies for IAM role for ECR access
# ====================================================================

resource "aws_iam_role_policy" "ecr_push" {
    name = "${var.environment}-ecr-push-policy"
    role = aws_iam_role.github_actions.id

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "ecr:GetAuthorizationToken"
                ]
                Resource = "*"
            },
            {
                Effect = "Allow"
                Action = [
                    "ecr:GetAuthorizationToken",
                    "ecr:BatchCheckLayerAvailability",
                    "ecr:GetDownloadUrlForLayer",
                    "ecr:BatchGetImage",
                    "ecr:PutImage",
                    "ecr:InitiateLayerUpload",
                    "ecr:UploadLayerPart",
                    "ecr:CompleteLayerUpload"
                ]
                Resource = "*"
            }
        ]
    })
}