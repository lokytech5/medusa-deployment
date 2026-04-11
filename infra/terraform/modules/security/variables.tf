variable "medusa_alb_sg_name" {
  type        = string
  description = "Actual name use for the security group"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the security group will be created"
}

variable "medusa_alb_sg_description" {
  type        = string
  description = "description name for the security group"
}

variable "medusa_alb_sg_ingress" {
  description = "ingress configuration"
  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

# Egress configuration for the security group
variable "medusa_alb_sg_egress" {
  description = "egress configuration"
  type = object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  })
}
