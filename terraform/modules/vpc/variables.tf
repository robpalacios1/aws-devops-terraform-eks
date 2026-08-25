# ====================================================================
# 1. VPC Variables
# ====================================================================

variable "aws_region" {
  description = "AWS Region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "main_vpc_cidr_block" {
  description = "Main VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

# ====================================================================
# 2. Public Subnet Variables
# ====================================================================

variable "public_subnet_cidr_block" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnet_az" {
  description = "Public subnet AZ"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# ====================================================================
# 3. Private Subnet Variables
# ====================================================================

variable "private_subnet_cidr_block" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "private_subnet_az" {
  description = "Private subnet AZ"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}