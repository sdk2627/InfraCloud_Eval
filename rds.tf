resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.private_subnet_rds_fw.id, aws_subnet.private_subnet_rds_fw2.id]

  tags = {
    Name = "My DB subnet group"
  }
}
resource "aws_db_parameter_group" "default" {
  name   = "rds-pg"
  family = "mysql8.0"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}
resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "faceworldMysqlDb"
  engine               = "mysql"
  engine_version       = "8.0.35"
  instance_class       = "db.t3.micro"
  username             = "fw_root"
  password             = "password"
  parameter_group_name = aws_db_parameter_group.default.name
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.default.name
}
