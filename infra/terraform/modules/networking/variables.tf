variable "vpc_cidr" {
  type        = string
  description = "Medusa VPC CIDR block"
}

variable "project_name" {
  type        = string
  description = "Project name"
}

variable "private_subnets" {
  description = "Private subnet configuration"
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
}

variable "public_subnets" {
  description = "Public subnet configuration"
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
}

variable "public_route_table_cidr" {
  type        = string
  description = "Route CIDR block for public route table"
}

variable "private_route_table_cidr" {
  type        = string
  description = "Route CIDR block for private route table"
}
