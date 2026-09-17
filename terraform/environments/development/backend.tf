terraform {
  required_version = ">= 1.9.0" 
    
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17.0"
    }
  }
  
  backend "s3" {
    bucket         = "my-project-tf-state-us-east-1"
    key            = "development/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-ha-dev-locks"
    encrypt        = true
  }
}