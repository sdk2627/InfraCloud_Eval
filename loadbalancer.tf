resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security Group pour ALB"
  vpc_id      = aws_vpc.faceworld-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "faceworld_alb" {
  name               = "faceworld-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet_rds_fw.id, aws_subnet.private_subnet_rds_fw.id, aws_subnet.private_subnet_rds_fw2.id]

  enable_deletion_protection = false

  tags = {
    Name = "faceworld-alb"
  }
}

resource "aws_lb_target_group" "faceworld_tg" {
  name     = "faceworld-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.faceworld-vpc.id
}

resource "aws_lb_listener" "faceworld_listener" {
  load_balancer_arn = aws_lb.faceworld_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.faceworld_tg.arn
  }
}
