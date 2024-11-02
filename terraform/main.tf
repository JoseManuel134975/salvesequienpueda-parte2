provider "aws" {
  region = "us-east-1" # Cambia a tu región preferida
}

resource "aws_vpc" "mi_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "mi_subred_publica" {
  vpc_id            = aws_vpc.mi_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a" # Cambia según tu región
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "mi_igw" {
  vpc_id = aws_vpc.mi_vpc.id
}

resource "aws_route_table" "mi_ruta_publica" {
  vpc_id = aws_vpc.mi_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mi_igw.id
  }
}

resource "aws_route_table_association" "mi_asociacion_ruta" {
  subnet_id      = aws_subnet.mi_subred_publica.id
  route_table_id = aws_route_table.mi_ruta_publica.id
}

resource "aws_instance" "mi_servidor_web" {
  ami           = "ami-0c55b159cbfafe01a" # Reemplaza con el ID de AMI que prefieras
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.mi_subred_publica.id

  user_data = file("user_data.sh")

  tags = {
    Name = "ServidorWeb"
  }
}

output "public_ip" {
  value = aws_instance.mi_servidor_web.public_ip
}
