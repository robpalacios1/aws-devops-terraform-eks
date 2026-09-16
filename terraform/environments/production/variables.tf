# ====================================================================
# Variables for production environment
# ====================================================================

variable "environment" {
  description = "Name of the environment"
  type        = string
  default     = "production"
}

variable "aws_region" {
  description = "AWS region to deploy the resources"
  type        = string
  default     = "production"
}