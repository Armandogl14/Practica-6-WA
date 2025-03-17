#!/bin/bash

# Habilitando la memoria de intecambio.
sudo dd if=/dev/zero of=/swapfile count=2048 bs=1MiB
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# Clonar el repositorio de GitHub
echo "Clonando el repositorio de GitHub..."
git clone https://github.com/Armandogl14/Test-P4-Web.git
cd Test-P4-Web || exit

# Moverse al directorio 'practica-4-compose'
echo "Moviéndose al directorio practica-4-compose..."
cd practica-4-composer-copy || exit

# Instalar Docker
echo "Instalando Docker..."
# Configuración para obtener Docker desde los repositorios oficiales
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

# Agregar la clave GPG de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Agregar el repositorio de Docker
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar Docker
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io -y

# Verificar que Docker se instaló correctamente
echo "Verificando la instalación de Docker..."
sudo docker --version

# Instalar Docker Compose (si es necesario)
echo "Instalando Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verificar la instalación de Docker Compose
echo "Verificando la instalación de Docker Compose..."
docker-compose --version

# Instalar Certbot
echo "Instalando Certbot..."
# Agregar repositorio de Certbot
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:certbot/certbot -y
sudo apt update

# Instalar Certbot
sudo apt install certbot python3-certbot-nginx -y

# Verificar la instalación de Certbot
echo "Verificando la instalación de Certbot..."
certbot --version

# Generar los certificados SSL con Certbot
echo "Generando los certificados SSL para tu dominio..."
# Asegúrate de tener un dominio configurado en tu servidor
# Reemplaza 'tu_dominio' por tu dominio real cuando lo tengas
sudo certbot --nginx -d agonzalez.me.turnos.do --agree-tos --no-eff-email --redirect --staple-ocsp -m ajgl0001@ce.pucmm.edu.do

# Verificar que los certificados se generaron correctamente
echo "Verificando los certificados SSL..."
sudo certbot certificates

# Detentiendo nginx para liberar el puerto 80
sudo systemctl stop nginx

# Ejecutar Docker Compose para levantar los servicios
echo "Levantando los servicios con Docker Compose..."
sudo docker-compose up -d

echo "El script ha finalizado correctamente."
