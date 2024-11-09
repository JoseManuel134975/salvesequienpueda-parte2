# Proveedor
provider "aws" {
  region = var.region # Variable definida en variables.tf y asignada en terraform.tfvars
}

# VPC
resource "aws_vpc" "mi_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc-nginx"
  }
}

# Grupo de seguridad
resource "aws_security_group" "allow_http_and_ssh" {
  name = "allow_http_and_ssh"
  description = "Permite el trafico HTTP y SSH para acceder a la instancia"
  vpc_id = aws_vpc.mi_vpc.id # Mediante el ID asociamos

  # Reglas de entrada
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ] # Desde cualquier lado
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  # Reglas de salida
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1" # Permite todos los puertos y protocolos
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

# Subred pública
resource "aws_subnet" "mi_subred_publica" {
  vpc_id = aws_vpc.mi_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true # Se asigna una IP pública automáticamente a las instancias creadas en esta subred

  tags = {
    Name = "subnet-for-nginx"
  }
}

# Router para salir a internet
resource "aws_internet_gateway" "mi_router" {
  vpc_id = aws_vpc.mi_vpc.id

  tags = {
    Name = "router-for-nginx"
  }
}

# Tabla de enrutamiento
resource "aws_route_table" "mi_tabla_de_enrutamiento" {
  vpc_id = aws_vpc.mi_vpc.id

  # Rutas
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mi_router.id
  }

  tags = {
    Name = "route_table-for-nginx"
  }
}

# Asociación entre tabla de rutas y subred
resource "aws_route_table_association" "mi_asociacion_de_tabla_de_enrutamiento" {
  route_table_id = aws_route_table.mi_tabla_de_enrutamiento.id
  subnet_id = aws_subnet.mi_subred_publica.id
}

resource "aws_key_pair" "keys_of_server_nginx" {
  key_name = "server-web-nginx"
  public_key = file("servidor-web-nginx.pub")
}

# Instancia (lo bueno)
resource "aws_instance" "mi_servidor_web" {
  key_name = aws_key_pair.keys_of_server_nginx.key_name
  ami = "ami-06b21ccaeff8cd686" # Se pueden hacer filtros pero también pasarle el ID directamente
  instance_type = "t2.micro" # Capa gratuita de AWS para crear instancias
  subnet_id = aws_subnet.mi_subred_publica.id
  vpc_security_group_ids = [ aws_security_group.allow_http_and_ssh.id ]
  user_data = file("user_data.sh") # Script que se ejecuta al crear la instancia

  tags = {
    Name = "servidor_nginx_linux_aws"
  }
}