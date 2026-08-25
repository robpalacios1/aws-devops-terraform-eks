terraform {
  backend "s3" {
    bucket         = "my-project-tf-state-us-east-1"
    key            = "production/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-ha-production-locks"
    encrypt        = true
  }
}