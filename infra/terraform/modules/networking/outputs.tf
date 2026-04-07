output "vpc_id" {
  value = aws_vpc.this.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.this.id
}

output "private_subnet_ids" {
  value = {
    for key, subnet in aws_subnet.private : key => subnet.id
  }
}

output "public_subnet_ids" {
  value = {
    for key, subnet in aws_subnet.public : key => subnet.id
  }
}

output "private_subnet_a_id" {
  value = aws_subnet.private["a"].id
}

output "private_subnet_b_id" {
  value = aws_subnet.private["b"].id
}

output "public_subnet_a_id" {
  value = aws_subnet.public["a"].id
}

output "public_subnet_b_id" {
  value = aws_subnet.public["b"].id
}

output "elastic_ip_id" {
  value = aws_eip.this.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.this.id
}

output "public_route_table_id" {
  value = aws_route_table.public_route_table.id
}

output "private_route_table_id" {
  value = aws_route_table.private_route_table.id
}
