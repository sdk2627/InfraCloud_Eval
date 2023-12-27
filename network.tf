resource "aws_vpc" "faceworld-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc-fw"
  }
}

resource "aws_subnet" "public_subnet_rds_fw" {
  vpc_id            = aws_vpc.faceworld-vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "eu-west-3c"
}

resource "aws_subnet" "private_subnet_rds_fw" {
  vpc_id            = aws_vpc.faceworld-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-3a"
}

resource "aws_subnet" "private_subnet_rds_fw2" {
  vpc_id            = aws_vpc.faceworld-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-3b"
}

resource "aws_internet_gateway" "igw_public_rds_fw" {
  vpc_id = aws_vpc.faceworld-vpc.id
}

resource "aws_eip" "eip_nat_rds_fw" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_priv_rds_fw" {
  allocation_id = aws_eip.eip_nat_rds_fw.id
  subnet_id     = aws_subnet.public_subnet_rds_fw.id
}

resource "aws_route_table" "route_table_public_rds_fw" {
  vpc_id = aws_vpc.faceworld-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_public_rds_fw.id
  }
}

resource "aws_route_table_association" "route_table_association_public_rds_fw" {
  subnet_id      = aws_subnet.public_subnet_rds_fw.id
  route_table_id = aws_route_table.route_table_public_rds_fw.id
}


resource "aws_route_table" "route_table_private_rds" {
  vpc_id = aws_vpc.faceworld-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_priv_rds_fw.id
  }
}

resource "aws_route_table_association" "route_table_association_private_rds" {
  subnet_id      = aws_subnet.private_subnet_rds_fw.id
  route_table_id = aws_route_table.route_table_private_rds.id
}

resource "aws_route_table_association" "route_table_association_private_rds_2" {
  subnet_id      = aws_subnet.private_subnet_rds_fw2.id
  route_table_id = aws_route_table.route_table_private_rds.id
}
