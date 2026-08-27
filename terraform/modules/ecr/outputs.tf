output "repository_urls" {
  description = "the urls of the ECR repositories"
  value = {
    for name, repo in aws_ecr_repository.this : name => repo.repository_url
  }
}

output "repository_names" {
  description = "the names of the ECR repositories"
  value = {
    for name, repo in aws_ecr_repository.this : name => repo.name
  }
}