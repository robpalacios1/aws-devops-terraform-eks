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

#EKS outputs
output "eks_cluster_name" {
  description = "the name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "the endpoint of the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_id" {
  description = "the id of the EKS cluster"
  value       = module.eks.cluster_id
}

output "configure_kubectl" {
  description = "command to configure kubectl locally"
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.aws_region}"
}
