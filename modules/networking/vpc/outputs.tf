output "vpc_id" {
  description = "ID of the created VPC."
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the created VPC."
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets (one per AZ)."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets (empty list unless enable_nat_gateway = true)."
  value       = aws_subnet.private[*].id
}

output "availability_zones" {
  description = "Availability zones used, in the same order as the subnet id lists."
  value       = local.azs
}
