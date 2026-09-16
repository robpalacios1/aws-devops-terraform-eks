variable "environment" {
  description = "the name of the environment (dev/staging/prod)"
  type        = string
  default     = "dev"
}

variable "repository_names" {
  description = "the list of ECR repositories to be created"
  type        = list(string)
  default = [
    "users-service",
    "orders-service",
    "products-service"
  ]
}