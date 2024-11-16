#!/bin/bash
# Actualiza el sistema e instala paquetes necesarios
sudo yum update -y
sudo yum install nginx -y
# sudo yum install php libnginx-mod-php -y
sudo yum install git -y

# Inicia el servidor web
sudo systemctl start nginx
sudo systemctl enable nginx

# Crea el directorio donde se alojará la web si no existe
sudo mkdir -p /usr/share/nginx/html/

# Clona tu repositorio en un directorio temporal
sudo git clone https://github.com/JoseManuel134975/salvesequienpueda-parte2.git /tmp/mi_proyecto

# # Crear el archivo PHP. Lo hice con un echo porque no tenía tiempo de meter PHP.
# sudo echo "<?php phpinfo(); ?>" > /tmp/mi_proyecto/src/index.php

# Copia los archivos de src a /usr/share/nginx/html
sudo cp -r /tmp/mi_proyecto/src/* /usr/share/nginx/html/

# Limpia el directorio temporal
sudo rm -rf /tmp/mi_proyecto

# Y cambia los permisos por si acaso hay problemas
sudo chown -R nginx:nginx /usr/share/nginx/html/
sudo chmod -R 755 /usr/share/nginx/html/