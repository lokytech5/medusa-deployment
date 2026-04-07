//VPC for Medusa application
# resource "aws_vpc" "medusa_vpc" {
#   cidr_block           = "10.0.0.0/16"
#   instance_tenancy     = "default"
#   enable_dns_support   = true
#   enable_dns_hostnames = true

#   tags = {
#     Name = "medusa-vpc"
#   }
# }

module "networking" {
  source = "./modules/networking"

  project_name = "medusa"
  vpc_cidr     = "10.0.0.0/16"
  private_subnets = {
    a = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
    }

    b = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1b"
    }
  }

  public_subnets = {
    a = {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "us-east-1a"
    }

    b = {
      cidr_block        = "10.0.4.0/24"
      availability_zone = "us-east-1b"
    }
  }
  public_route_table_cidr  = "0.0.0.0/0"
  private_route_table_cidr = "0.0.0.0/0"
}


# private_subnet_a_cidr       = "10.0.1.0/24"
# private_subnet_b_cidr       = "10.0.2.0/24"
# private_availability_zone_a = "us-east-1a"
# private_availability_zone_b = "us-east-1b"
# //Medusa Elastic IP 
# resource "aws_eip" "medusa_nat_eip" {
#   domain = "vpc"

#   tags = {
#     Name = "medusa-nat-eip"
#   }
# }


# //Medusa private subnet A
# resource "aws_subnet" "medusa_private_subnet_a" {
#   vpc_id                  = module.networking.vpc_id
#   cidr_block              = "10.0.1.0/24"
#   availability_zone       = "us-east-1a"
#   map_public_ip_on_launch = false
#   tags = {
#     Name = "medusa-private-subnet-a"
#   }
# }

# //Medusa private subnet B
# resource "aws_subnet" "medusa_private_subnet_b" {
#   vpc_id                  = module.networking.vpc_id
#   cidr_block              = "10.0.2.0/24"
#   map_public_ip_on_launch = false
#   availability_zone       = "us-east-1b"
#   tags = {
#     Name = "medusa-private-subnet-b"
#   }
# }

# //Medusa public subnet A
# resource "aws_subnet" "medusa_public_subnet_a" {
#   vpc_id                  = module.networking.vpc_id
#   cidr_block              = "10.0.3.0/24"
#   availability_zone       = "us-east-1a"
#   map_public_ip_on_launch = true
#   tags = {
#     Name = "medusa-public-subnet-a"
#   }
# }

# //Medusa public subnet B
# resource "aws_subnet" "medusa_public_subnet_b" {
#   vpc_id                  = module.networking.vpc_id
#   cidr_block              = "10.0.4.0/24"
#   availability_zone       = "us-east-1b"
#   map_public_ip_on_launch = true
#   tags = {
#     Name = "medusa-public-subnet-b"
#   }
# }

//medusa internet gateway
# resource "aws_internet_gateway" "medusa_igw" {
#   vpc_id = module.networking.vpc_id

#   tags = {
#     Name = "medusa-igw"
#   }
# }

//medusa nat gaetway
# resource "aws_nat_gateway" "medusa_nat_gateway" {
#   allocation_id = module.networking.elastic_ip_id
#   subnet_id     = module.networking.public_subnet_a_id
#   tags = {
#     Name = "medusa-nat-gateway"
#   }

#   depends_on = [module.networking]
# }

# //medusa private route table
# resource "aws_route_table" "medusa_private_route_table" {
#   vpc_id = module.networking.vpc_id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = module.networking.nat_gateway_id
#   }

#   tags = {
#     Name = "medusa-private-route-table"
#   }
# }

# //medusa public route table
# resource "aws_route_table" "medusa_public_route_table" {
#   vpc_id = module.networking.vpc_id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = module.networking.internet_gateway_id
#   }

#   tags = {
#     Name = "medusa-public-route-table"
#   }
# }

# //medusa route table association for public subnet A
# resource "aws_route_table_association" "medusa_public_subnet_association_a" {
#   subnet_id      = module.networking.public_subnet_a_id
#   route_table_id = aws_route_table.medusa_public_route_table.id
# }

# //medusa route table association for public subnet B
# resource "aws_route_table_association" "medusa_public_subnet_association_b" {
#   subnet_id      = module.networking.public_subnet_b_id
#   route_table_id = aws_route_table.medusa_public_route_table.id
# }

# //medusa route table association for private subnet A
# resource "aws_route_table_association" "medusa_private_subnet_association_a" {
#   subnet_id      = module.networking.private_subnet_a_id
#   route_table_id = aws_route_table.medusa_private_route_table.id
# }

# //medusa route table association for private subnet B
# resource "aws_route_table_association" "medusa_private_subnet_association_b" {
#   subnet_id      = module.networking.private_subnet_b_id
#   route_table_id = aws_route_table.medusa_private_route_table.id
# }
