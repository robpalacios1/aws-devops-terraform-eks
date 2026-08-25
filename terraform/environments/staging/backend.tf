terraform {
  backend "s3" {
    bucket         = "my-project-tf-state-us-east-1"
    key            = "staging/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-ha-staging-locks"
    encrypt        = true
  }
}