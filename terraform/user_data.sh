#!/bin/bash
# Actualiza y instala Nginx
sudo yum update -y
sudo yum install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Crea el directorio /var/www/html si no existe
sudo mkdir -p /usr/share/nginx/html

# Clona tu repositorio en un directorio temporal
# Cambia <tu-repo-url> por la URL de tu repositorio
sudo git clone https://github.com/JoseManuel134975/salvesequienpueda-parte2.git /tmp/mi_proyecto

# Copia los archivos de src a /var/www/html
cp -r /tmp/mi_proyecto/src/* /usr/share/nginx/html

# Limpia el directorio temporal
rm -rf /tmp/mi_proyecto

sudo chown -R nginx:nginx /usr/share/nginx/html
sudo chmod -R 755 /usr/share/nginx/html