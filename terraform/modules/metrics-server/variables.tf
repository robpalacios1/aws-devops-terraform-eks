variable "environment" {
    description = "Environment name"
    type        = string
    default     = "dev"
}

variable "chart_version" {
    description = "Metrics Server Chart Version"
    type        = string
    default     = "3.12.1"
}
