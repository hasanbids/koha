#!/bin/bash

set -e

echo "Updating system..."
sudo apt update && sudo apt upgrade -y

echo "Installing dependencies..."
sudo apt install -y gnupg2 curl software-properties-common apt-transport-https

echo "Adding Koha 24.11 repository..."
echo 'deb http://debian.koha-community.org/koha 24.11 main' | sudo tee /etc/apt/sources.list.d/koha.list

echo "Adding Koha GPG key..."
curl https://debian.koha-community.org/koha/gpg.asc | sudo apt-key add -

echo "Updating package list..."
sudo apt update

echo "Installing Koha..."
sudo apt install -y koha-common

echo "Configuring ports..."
sudo sed -i 's/OPACPORT="80"/OPACPORT="8080"/' /etc/koha/koha-sites.conf

echo "Enabling Apache modules..."
sudo a2enmod rewrite
sudo a2enmod proxy
sudo a2enmod proxy_http

read -p "Enter Koha instance name: " INSTANCE

echo "Creating Koha instance..."
sudo koha-create --create-db $INSTANCE

echo "Enabling site..."
sudo a2ensite $INSTANCE
sudo systemctl reload apache2

echo "Starting Zebra..."
sudo koha-start-zebra $INSTANCE

echo "Setting admin password..."
sudo koha-passwd $INSTANCE kohaadmin

echo "Done!"
echo "OPAC: http://localhost:8080"
echo "Staff: http://localhost:8081"
