# ====================================================================
# Variables for development environment
# ====================================================================

variable "environment" {
  description = "Name of the environment"
  type        = string
  default     = "development"
}

variable "aws_region" {
  description = "AWS region to deploy the resources"
  type        = string
  default     = "us-east-1"
}
  