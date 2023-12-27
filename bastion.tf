# Ici on veut créer une instance EC2 qui servira de bastion pour se connecter à la base de données RDS
# On utilise une AMI Amazon Linux 2
# On utilise un Security Group qui autorise les connexions SSH depuis notre IP publique
# On utilise une clé SSH pour se connecter à l'instance
# On utilise un Elastic IP pour pouvoir se connecter à l'instance même si elle est recréée
# Utilisation d'une AMI Amazon Linux 2

data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "sg_bastion" {
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
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.bastion_key.key_name
  subnet_id                   = aws_subnet.public_subnet_rds_fw.id
  vpc_security_group_ids      = [aws_security_group.sg_bastion.id]
  associate_public_ip_address = true

  tags = {
    Name = "Bastion"
  }
}

resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion-key-fw"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDrT1B6R1rdC/4dZ3sG3mezdIV/ZnagsuIlE4J8Xpd8QW0MbHAdaLyB8yYE/XikvM4LKVMh0CqUVMLx8olf2zE34ZWZGkFUFLXAg/5XRz0lwkak0ZAZj5QDUEvvPq6EwY2X/fSJ12OeqRH4Euhl21zRfczTgj9FaiAr0eOpT0vg/G/1UoS+0dPT5i5mcLCR8/91B2vfihEveTI1OVJUmXKaZctFd7VDi4pvsPaKH1B+iZeV+7JR7o+8FIk0FwJw+wXKntJEhY65fQ60k8oECSi437FoJdQvGUViih42qig/6pgkI0mWZxqk62ITUCgmR0YwwTnbwdjq0vPeBUM9BdIN0bIKTxRdQ+noQ1O8F1XwuSN8eOB7wZzF4fC8wD75KjJyVGwoXuXCb8TcBrIZg8QCbHmMbqVr7Lv4zS5cAGBxjTQC0LMBpeV4ImTOY67bFch85Vj/DfnU5XwIRg5UoRBMuLjN5V0DMn0ZhjDPjbbTIJkJIqjPWKk4zl5q5uJR0fs= ouyah@Nitro_de_Saddek"
}

resource "aws_eip" "bastion_eip" {
  instance = aws_instance.bastion.id
}
