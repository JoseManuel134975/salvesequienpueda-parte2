# Proveedor
provider "aws" {
  region = "us-east-1" # Región
}

# Grupo de seguridad
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP traffic"
  vpc_id      = aws_vpc.mi_vpc.id  # Asocia el grupo de seguridad a la VPC creada

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permitir tráfico HTTP desde cualquier dirección IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Permitir todo el tráfico saliente
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# VPC
resource "aws_vpc" "mi_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Subred pública
resource "aws_subnet" "mi_subred_publica" {
  vpc_id            = aws_vpc.mi_vpc.id # Asocia la subred a la VPC
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a" # Zona de disponibilidad
  map_public_ip_on_launch = true # Se asigna una IP pública automáticamente a las instancias que se creen en esta subred
}

# Puerta de enlace (router) necesario para salir a internet
resource "aws_internet_gateway" "mi_igw" {
  vpc_id = aws_vpc.mi_vpc.id # Asocia a la VPC
}

# Tabla de enrutamiento
resource "aws_route_table" "mi_ruta_publica" {
  vpc_id = aws_vpc.mi_vpc.id

  route {
    cidr_block = "0.0.0.0/0" # Permite tráfico a cualquier sitio
    gateway_id = aws_internet_gateway.mi_igw.id # Asocia a la puerta de enlace
  }
}

# Más asociación 
resource "aws_route_table_association" "mi_asociacion_ruta" {
  subnet_id      = aws_subnet.mi_subred_publica.id # Subred especificada
  route_table_id = aws_route_table.mi_ruta_publica.id # Tabla de rutas
}

# Instancia (lo bueno)
resource "aws_instance" "mi_servidor_web" {
  ami           = "ami-06b21ccaeff8cd686" # ID de la imagen para instalar el sistema operativo (se consigue desde las ami asociadas a nuestra región en aws)
  instance_type = "t2.micro" # Tipo de instancia (esta es el nivel gratuito...)
  subnet_id     = aws_subnet.mi_subred_publica.id # Subred donde se despliega

  vpc_security_group_ids = [aws_security_group.allow_http.id]  # Asocia el grupo de seguridad

  user_data = file("user_data.sh") # Script ejecutable al iniciar la instancia

  # Etiqueta para nombrar la instancia
  tags = {
    Name = "ServidorWeb"
  }
}

# Muestra la IP pública de la instancia 
output "public_ip" {
  value = aws_instance.mi_servidor_web.public_ip
}
