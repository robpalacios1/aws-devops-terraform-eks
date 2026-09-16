# ====================================================================
# Variables for staging environment
# ====================================================================

variable "environment" {
  description = "Name of the environment"
  type        = string
  default     = "staging"
}

variable "aws_region" {
  description = "AWS region to deploy the resources"
  type        = string
  default     = "us-east-1"
}