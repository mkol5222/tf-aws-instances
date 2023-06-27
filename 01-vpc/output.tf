output "public_subnet_id" {
    value = aws_subnet.public_subnet[0].id
  
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}