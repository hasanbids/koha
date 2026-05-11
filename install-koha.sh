#!/bin/bash

set -e

echo "Updating system..."
sudo apt update && sudo apt upgrade -y

echo "Installing dependencies..."
sudo apt install -y gnupg2 curl software-properties-common apt-transport-https

echo "Adding Koha repository..."
echo 'deb http://debian.koha-community.org/koha 24.11 main' | sudo tee /etc/apt/sources.list.d/koha.list

echo "Adding Koha GPG key..."
curl https://debian.koha-community.org/koha/gpg.asc | sudo gpg --dearmor -o /usr/share/keyrings/koha.gpg

echo "Fixing repository signing..."
echo "deb [signed-by=/usr/share/keyrings/koha.gpg] http://debian.koha-community.org/koha 24.11 main" | sudo tee /etc/apt/sources.list.d/koha.list

echo "Updating package list..."
sudo apt update

echo "Installing MariaDB..."
sudo apt install -y mariadb-server

echo "Starting MariaDB..."
sudo systemctl enable mariadb
sudo systemctl start mariadb

echo "Installing Koha..."
sudo apt install -y koha-common

echo "Configuring ports..."
sudo sed -i 's/OPACPORT="80"/OPACPORT="8080"/' /etc/koha/koha-sites.conf
sudo sed -i 's/INTRAPORT="8081"/INTRAPORT="8081"/' /etc/koha/koha-sites.conf

echo "Enabling Apache modules..."
sudo a2enmod rewrite
sudo a2enmod proxy
sudo a2enmod proxy_http

read -p "Enter Koha instance name: " INSTANCE

echo "Creating Koha instance..."
sudo koha-create --create-db $INSTANCE

echo "Enabling site..."
sudo a2ensite $INSTANCE

echo "Restarting Apache..."
sudo systemctl restart apache2

echo "Starting Zebra..."
sudo koha-start-zebra $INSTANCE

echo "Set Koha admin password:"
sudo koha-passwd $INSTANCE kohaadmin

echo ""
echo "Installation complete!"
echo "OPAC:  http://localhost:8080"
echo "Staff: http://localhost:8081"
