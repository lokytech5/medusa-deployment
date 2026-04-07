resource "aws_db_subnet_group" "medusa_app_db_subnet" {
  name       = "medusa-app-db-subnet"
  subnet_ids = [module.networking.private_subnet_a_id, module.networking.private_subnet_b_id]

  tags = {
    Name = "medusa db subnet"
  }
}

resource "aws_db_parameter_group" "medusa_postgres_params" {
  name   = "medusa-postgres17-params"
  family = "postgres17"

  parameter {
    name  = "rds.force_ssl"
    value = "0"
  }

  tags = {
    Name = "medusa-postgres17-params"
  }
}

resource "aws_db_instance" "medusa_postgres_db" {
  identifier             = "medusa-postgres-db"
  allocated_storage      = 10
  db_name                = "medusa_db"
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  username               = "medusa_user"
  password               = "admin123"
  multi_az               = false
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.medusa_app_db_subnet.name
  vpc_security_group_ids = [aws_security_group.medusa_db_sg.id]
  publicly_accessible    = false
  deletion_protection    = false
  apply_immediately      = true
  parameter_group_name   = aws_db_parameter_group.medusa_postgres_params.name

  tags = {
    Name = "medusa-postgres-db"
  }
}
