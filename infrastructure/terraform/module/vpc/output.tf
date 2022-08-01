output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets_id" {
  value = [aws_subnet.public_subnets.*.id]
}

output "private_subnets_id" {
  value = [aws_subnet.private_subnets.*.id]
}

output "security_groups_ids" {
  value = [aws_security_group.default_security_group.id]
}

output "public_route_table" {
  value = aws_route_table.public_rtb.id
}
