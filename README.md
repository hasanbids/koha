chmod +x install-koha.sh
./install-koha.sh

echo "Listen 8080" | sudo tee -a /etc/apache2/ports.conf
echo "Listen 8081" | sudo tee -a /etc/apache2/ports.conf
sudo systemctl restart apache2

sudo mysql -e "CREATE DATABASE koha_bidslib DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
sudo mysql -e "CREATE USER IF NOT EXISTS 'koha_bidslib'@'localhost' IDENTIFIED BY 'koha';"
sudo mysql -e "GRANT ALL PRIVILEGES ON koha_bidslib.* TO 'koha_bidslib'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"
sudo koha-mysql bidslib < /usr/share/koha/intranet/cgi-bin/installer/data/mysql/kohastructure.sql
sudo koha-mysql bidslib -e "show tables;"

ls /usr/share/koha/intranet/cgi-bin/installer/data/mysql/
sudo apt install --reinstall koha-common

sudo koha-mysql bidslib < /usr/share/koha/intranet/cgi-bin/installer/data/mysql/kohastructure.sql
