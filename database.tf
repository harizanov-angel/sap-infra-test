# Database subnet group
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = aws_subnet.database[*].id

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

# RDS PostgreSQL instance with managed secrets
resource "aws_db_instance" "main" {
  identifier = "${var.project_name}-db"

  engine         = "postgres"
  engine_version = "17.4"
  instance_class = var.db_instance_class

  allocated_storage     = 20
  max_allocated_storage = 50
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.db_username

  # Use AWS managed secrets for password
  manage_master_user_password = true
  master_user_secret_kms_key_id = "alias/aws/secretsmanager"

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"

  skip_final_snapshot = true
  deletion_protection = false

  tags = {
    Name = "${var.project_name}-db"
  }
}

# SSM Parameter for database host (static name that app can find)
resource "aws_ssm_parameter" "db_host" {
  name  = "/${var.project_name}/db-host"
  type  = "String"
  value = aws_db_instance.main.address

  tags = {
    Name = "${var.project_name}-db-host-ssm"
  }
}

# Data source to get the managed RDS secret (dynamic name)
data "aws_secretsmanager_secret" "rds_managed_secret" {
  name = aws_db_instance.main.master_user_secret[0].secret_arn
}

data "aws_secretsmanager_secret_version" "rds_managed_secret" {
  secret_id = data.aws_secretsmanager_secret.rds_managed_secret.id
}

 