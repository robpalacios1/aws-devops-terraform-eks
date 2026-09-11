variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "EKS Cluster name"
  type        = string
}

variable "cluster_oidc_issuer_url" {
  description = "EKS Cluster OIDC issuer URL"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}