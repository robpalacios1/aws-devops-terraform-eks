output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main_vpc.id
  
}

output "public_subnet_ids" {
  description = "Public Subnet ID's"
  value       = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]
  
}

output "private_subnet_ids" {
  description = "Private Subnet ID's"
  value       = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.main_gw.id
}
