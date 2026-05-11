chmod +x install-koha.sh
./install-koha.sh

echo "Listen 8080" | sudo tee -a /etc/apache2/ports.conf
echo "Listen 8081" | sudo tee -a /etc/apache2/ports.conf
sudo systemctl restart apache2
