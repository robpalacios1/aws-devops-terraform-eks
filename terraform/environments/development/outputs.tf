#VPC Outputs
output "vpc_id" {
  description = "vpc id"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "public subnet id's"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "private subnet id's"
  value       = module.vpc.private_subnet_ids
}

output "nat_gateway_id" {
  description = "nat gateway id"
  value       = module.vpc.nat_gateway_id
}

#ECR Outputs
output "repository_urls" {
  description = "the urls of the ECR repositories"
  value       = module.ecr.repository_urls
}

output "repository_names" {
  description = "the names of the ECR repositories"
  value       = module.ecr.repository_names
}
