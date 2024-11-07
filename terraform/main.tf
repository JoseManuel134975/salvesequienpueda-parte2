# # Proveedor
# provider "aws" {
#   region = "us-east-1" # Región
# }

# # Grupo de seguridad
# resource "aws_security_group" "allow_http" {
#   name        = "allow_http"
#   description = "Allow HTTP traffic"
#   vpc_id      = aws_vpc.mi_vpc.id  # Asocia el grupo de seguridad a la VPC creada

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]  # Permitir tráfico HTTP desde cualquier dirección IP
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"  # Permitir todo el tráfico saliente
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # VPC
# resource "aws_vpc" "mi_vpc" {
#   cidr_block = "10.0.0.0/16"
#   enable_dns_support = true
#   enable_dns_hostnames = true
# }

# # Subred pública
# resource "aws_subnet" "mi_subred_publica" {
#   vpc_id            = aws_vpc.mi_vpc.id # Asocia la subred a la VPC
#   cidr_block        = "10.0.1.0/24"
#   availability_zone = "us-east-1a" # Zona de disponibilidad
#   map_public_ip_on_launch = true # Se asigna una IP pública automáticamente a las instancias que se creen en esta subred
# }

# # Puerta de enlace (router) necesario para salir a internet
# resource "aws_internet_gateway" "mi_igw" {
#   vpc_id = aws_vpc.mi_vpc.id # Asocia a la VPC
# }

# # Tabla de enrutamiento
# resource "aws_route_table" "mi_ruta_publica" {
#   vpc_id = aws_vpc.mi_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0" # Permite tráfico a cualquier sitio
#     gateway_id = aws_internet_gateway.mi_igw.id # Asocia a la puerta de enlace
#   }
# }

# # Más asociación 
# resource "aws_route_table_association" "mi_asociacion_ruta" {
#   subnet_id      = aws_subnet.mi_subred_publica.id # Subred especificada
#   route_table_id = aws_route_table.mi_ruta_publica.id # Tabla de rutas
# }

# # Instancia (lo bueno)
# resource "aws_instance" "mi_servidor_web" {
#   ami           = "ami-06b21ccaeff8cd686" # ID de la imagen para instalar el sistema operativo (se consigue desde las ami asociadas a nuestra región en aws)
#   instance_type = "t2.micro" # Tipo de instancia (esta es el nivel gratuito...)
#   subnet_id     = aws_subnet.mi_subred_publica.id # Subred donde se despliega

#   vpc_security_group_ids = [aws_security_group.allow_http.id]  # Asocia el grupo de seguridad

#   user_data = file("user_data.sh") # Script ejecutable al iniciar la instancia

#   # Etiqueta para nombrar la instancia
#   tags = {
#     Name = "ServidorWeb"
#   }
# }

# # Muestra la IP pública de la instancia 
# output "public_ip" {
#   value = aws_instance.mi_servidor_web.public_ip
# }

# Proveedor
provider "aws" {
  region = var.region # Variable definida en variables.tf y asignada en terraform.tfvars
}

# VPC
resource "aws_vpc" "mi_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Grupo de seguridad
resource "aws_security_group" "allow_http_and_ssh" {
  description = "Permite el trafico HTTP y SSH para acceder a la instancia"
  vpc_id = aws_vpc.mi_vpc.id # Mediante el ID asociamos

  # Reglas de entrada
  ingress {
    from_port = 80
    to_port = 80
    protocol = "HTTP"
    cidr_blocks = [ "0.0.0.0/0" ] # Desde cualquier lado
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "SSH"
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

# # Regla de entrada
# resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
#   security_group_id = aws_security_group.allow_http.id
#   cidr_ipv4 = aws_vpc.mi_vpc.cidr_block
#   from_port = 80
#   ip_protocol = "HTTP"
#   to_port = 80
# }

# # Regla de salida
# resource "aws_vpc_security_group_egress_rule" "allow_all_http_ipv4" {
#   security_group_id = aws_security_group.allow_http.id
#   cidr_ipv4 = "0.0.0.0/0"
#   ip_protocol = "-1" # Todos los puertos
# }

# Subred pública
resource "aws_subnet" "mi_subred_publica" {
  vpc_id = aws_vpc.mi_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true # Se asigna una IP pública automáticamente a las instancias creadas en esta subred
}

# Router para salir a internet
resource "aws_internet_gateway" "mi_router" {
  vpc_id = aws_vpc.mi_vpc.id
}

# Tabla de enrutamiento
resource "aws_route_table" "mi_tabla_de_enrutamiento" {
  vpc_id = aws_vpc.mi_vpc.id

  # Rutas
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mi_router.id
  }
}

# Asociación entre tabla de rutas y subred
resource "aws_route_table_association" "mi_asociacion_de_tabla_de_enrutamiento" {
  route_table_id = aws_route_table.mi_tabla_de_enrutamiento.id
  subnet_id = aws_subnet.mi_subred_publica.id
}

# Instancia (lo bueno)
resource "aws_instance" "mi_servidor_web" {
  ami = "ami-06b21ccaeff8cd686" # Se pueden hacer filtros pero también pasarle el ID directamente
  instance_type = "t2.micro" # Capa gratuita de AWS para crear instancias
  subnet_id = aws_subnet.mi_subred_publica.id
  vpc_security_group_ids = [ aws_security_group.allow_http_and_ssh.id ]
  user_data = file("user_data.sh") # Script que se ejecuta al crear la instancia
}