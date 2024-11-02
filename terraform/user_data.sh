#!/bin/bash
# Actualiza y instala Nginx
yum update -y
yum install -y nginx
systemctl start nginx
systemctl enable nginx

# Crea el directorio /var/www/html si no existe
mkdir -p /var/www/html

# Clona tu repositorio en un directorio temporal
# Cambia <tu-repo-url> por la URL de tu repositorio
git clone https://github.com/JoseManuel134975/salvesequienpueda-parte2.git /tmp/mi_proyecto

# Copia los archivos de src a /var/www/html
cp -r /tmp/mi_proyecto/src/* /var/www/html/

# Limpia el directorio temporal
rm -rf /tmp/mi_proyecto
