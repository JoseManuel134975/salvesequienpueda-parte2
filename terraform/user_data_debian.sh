#!/bin/bash
# Actualiza el sistema e instala paquetes necesarios
sudo apt update -y
sudo apt install nginx -y
sudo apt install git -y
sudo apt install apache2-utils -y

# Inicia el servidor web
sudo systemctl start nginx
sudo systemctl enable nginx

# Crea el directorio donde se alojará la web si no existe
sudo mkdir -p /var/www/html

# Clona tu repositorio en un directorio temporal
sudo git clone https://github.com/JoseManuel134975/salvesequienpueda-parte2.git /tmp/mi_proyecto

# Copia los archivos de src a /usr/share/nginx/html
sudo cp -r /tmp/mi_proyecto/src/* /var/www/html

# Limpia el directorio temporal
sudo rm -rf /tmp/mi_proyecto

# Y cambia los permisos por si acaso hay problemas
sudo chown -R nginx:nginx /var/www/html
sudo chmod -R 755 /var/www/html



# Puntos:
# 2-
sudo sed -i 's|root /var/www/html|root /var/www/otro|' /etc/nginx/sites-available/default
sudo systemctl restart nginx

# 3-
sudo sed -i 's|listen 80|listen 2512|' /etc/nginx/sites-available/default
sudo systemctl restart nginx

# 4-
sudo sed -i '/location \/ {/a\    autoindex on;' /etc/nginx/sites-available/default
sudo systemctl restart nginx

# 5- Redireccionar a HTTPS. Hay variantes para una URL específica y demás***
sudo sed -i '/listen \[::\]:80 default_server;/a\    return 301 https://$host$request_uri;' /etc/nginx/sites-available/default
sudo systemctl restart nginx
# Para una temporal se usa 'return 302'

# 6- Se le pasa el número del error (404 en este caso) y la correspondiente página HTML (creada por ti)
sudo mkdir /error_pages
sudo touch /error_pages/404.html
sudo echo '<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Página no encontrada</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            margin-top: 50px;
            color: #333;
        }
        h1 {
            font-size: 72px;
            color: #e74c3c;
        }
        p {
            font-size: 24px;
        }
        a {
            color: #3498db;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <h1>404</h1>
    <p>La página que buscas no existe o ha sido movida.</p>
    <p><a href="/">Volver al inicio</a></p>
</body>
</html>' | sudo tee /error_pages/404.html > /dev/null

sudo sed -i '/listen \[::\]:80 default_server;/a\    error_page 404 /error_pages/404.html;' /etc/nginx/sites-available/default
sudo systemctl restart nginx

# 7- 
sudo sed -i '/http {/i \
map \$http_accept_language \$lang {\
    default "en";\
    "~^es" "es";\
    "~^en" "en";\
}\
' /etc/nginx/nginx.conf
sudo sed -i '/location \/ {/,/}/s|try_files $uri $uri/ =404;|try_files /$lang/index.html /index.html;|' /etc/nginx/sites-available/default
sudo systemctl restart nginx

# 8
sudo cp /etc/nginx/sites-available/default otrositio
# Se le cambia, por ejemplo la ruta para que nos lleve a otro index.html*
sudo sed -i 's|root /var/www/otro|root /var/www/otromas|' /etc/nginx/sites-available/otrositio
sudo mkdir /var/www/otromas
sudo touch /var/www/otromas/index.html
sudo echo '<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <h1>¡HOLA!</h1>
</body>
</html>' > /var/www/otromas/index.html
# Habilita el sitio con un enlace simbólico
sudo ln -s /etc/nginx/sites-available/otrositio /etc/nginx/sites-enabled/
# Desabilita el sitio por defecto (no quería comerme la cabeza)
sudo rm /etc/nginx/sites-enabled/default
sudo systemctl restart nginx

# 9
sudo htpasswd -cb /etc/nginx/.htpasswd usuario usuario
sudo sed -i '/location \/ {/a\    auth_basic "Área Restringida";\n    auth_basic_user_file /etc/nginx/.htpasswd;' /etc/nginx/sites-available/otrositio
sudo systemctl restart nginx