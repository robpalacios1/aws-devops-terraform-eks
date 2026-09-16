output "role_arn" {
  description = "ARN for AWS Load Balancer Controller"
  value       = aws_iam_role.lbc.arn
}