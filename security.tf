# Ici on créé les Security Groups pour la base de données RDS, pour le bastion et pour l'application
# On utilise un Security Group pour la base de données RDS qui autorise les connexions depuis le Security Group de l'application et depuis le Security Group du bastion

resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Security Group pour le bastion"
  vpc_id      = aws_vpc.faceworld-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["85.169.101.162/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

resource "aws_security_group" "web_app_sg" {
  name        = "web-app-sg"
  description = "Security Group pour lapplication web"
  vpc_id      = aws_vpc.faceworld-vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.faceworld-vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-app-sg"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Security Group pour RDS"
  vpc_id      = aws_vpc.faceworld-vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_app_sg.id, aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}
