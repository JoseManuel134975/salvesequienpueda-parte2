#!/bin/bash
# Actualiza el sistema e instala paquetes necesarios
sudo apt update
sudo apt install apache2
sudo apt install php libapache2-mod-php
sudo apt install git

# Inicia el servidor web
sudo systemctl start apache2
sudo systemctl enable apache2

# Crea el directorio donde se alojará la web si no existe
sudo mkdir -p /var/www/html

# Clona tu repositorio en un directorio temporal
sudo git clone https://github.com/JoseManuel134975/salvesequienpueda-parte2.git /tmp/mi_proyecto

# Crear el archivo PHP
sudo echo "<?php phpinfo(); ?>" > /tmp/mi_proyecto/src/index.php

# Copia los archivos de src a /usr/share/nginx/html
sudo cp -r /tmp/mi_proyecto/src/* /var/www/html

# Limpia el directorio temporal
sudo rm -rf /tmp/mi_proyecto

# Y cambia los permisos por si acaso hay problemas
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html