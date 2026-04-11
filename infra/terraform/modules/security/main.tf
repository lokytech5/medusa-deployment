resource "aws_security_group" "this" {
  name        = var.medusa_alb_sg_name
  description = var.medusa_alb_sg_description
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.medusa_alb_sg_ingress
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  egress {
    from_port   = var.medusa_alb_sg_egress.from_port
    to_port     = var.medusa_alb_sg_egress.to_port
    protocol    = var.medusa_alb_sg_egress.protocol
    cidr_blocks = var.medusa_alb_sg_egress.cidr_blocks
  }
}
