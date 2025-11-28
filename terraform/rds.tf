resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = local.filtered_subnets
}

resource "aws_db_instance" "rds" {
  allocated_storage           = var.db_allocated_storage
  identifier                  = var.db_identifier
  engine                      = var.db_engine
  engine_version              = var.db_engine_version
  instance_class              = var.db_instance_class
  username                    = var.db_username
  db_subnet_group_name        = aws_db_subnet_group.default.name
  publicly_accessible         = true
  vpc_security_group_ids      = [aws_security_group.rds_sg.id]
  manage_master_user_password = true
  skip_final_snapshot         = true
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.db_identifier}-sg"
  description = "Permite acesso ao Postgres a partir do cluster EKS"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.db_identifier}-sg"
  }
}
