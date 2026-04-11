output "medusa_alb_sg_id" {
  value       = aws_security_group.this.id
  description = "Id for the security group"
}

output "medusa_alb_sg_name" {
  value       = aws_security_group.this.name
  description = "Name of the security group"
}
