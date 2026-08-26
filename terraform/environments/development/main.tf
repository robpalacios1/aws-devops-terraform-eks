provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source      = "../../modules/vpc"
  environment = var.environment
  aws_region  = var.aws_region
}
  