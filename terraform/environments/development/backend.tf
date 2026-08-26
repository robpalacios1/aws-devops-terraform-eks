terraform {
  backend "s3" {
    bucket         = "my-project-tf-state-us-east-1"
    key            = "${var.environment}/terraform.tfstate"
    region         = var.aws_region
    dynamodb_table = "terraform-ha-dev-locks"
    encrypt        = true
  }
}