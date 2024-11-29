#!/bin/bash
# Actualiza el sistema e instala paquetes necesarios
sudo apt update -y
sudo apt install nginx -y
sudo apt install git -y

# Inicia el servidor web
sudo systemctl start nginx
sudo systemctl enable nginx

# Crea el directorio donde se alojará la web si no existe
sudo mkdir -p /usr/share/nginx/html/

# Clona tu repositorio en un directorio temporal
sudo git clone https://github.com/JoseManuel134975/salvesequienpueda-parte2.git /tmp/mi_proyecto

# Copia los archivos de src a /usr/share/nginx/html
sudo cp -r /tmp/mi_proyecto/src/* /usr/share/nginx/html/

# Limpia el directorio temporal
sudo rm -rf /tmp/mi_proyecto

# Y cambia los permisos por si acaso hay problemas
sudo chown -R nginx:nginx /usr/share/nginx/html/
sudo chmod -R 755 /usr/share/nginx/html/