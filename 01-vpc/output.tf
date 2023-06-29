output "public_subnet_id" {
    value = aws_subnet.public_subnet[0].id
  
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "one_more_security_group_id" {
  value = aws_security_group.one_more.id
}