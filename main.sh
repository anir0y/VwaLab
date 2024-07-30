#!/bin/bash
# Encoded and added to main.sh by @anir0y
# not working on my local machine
# so base64 it and add it to main.sh
echo "Running main.sh"
# Create necessary directories
mkdir -p /var/www/html/images
rm -rf /var/www/html/index.html
# Set permissions
chmod 777 -R /var/www/html/images
chown www-data:www-data -R /var/www/html
# Start MySQL
echo '[+] Starting mysql...'
mysqld_safe &
sleep 5
# Initialize the database if needed
if [ ! -d "/var/lib/mysql/vwa" ]; then
    echo "Initializing database..."
    mysql_install_db --user=mysql --ldata=/var/lib/mysql/
    mysqld_safe &
    sleep 5
    mysql -uroot -e "CREATE USER 'app'@'localhost' IDENTIFIED BY 'vulnerables'; CREATE DATABASE vwa; GRANT ALL PRIVILEGES ON vwa.* TO 'app'@'localhost';"
    mysql -uroot -pvulnerables vwa < /docker-entrypoint-initdb.d/db.sql
    mysqladmin -uroot shutdown
fi
# Restart MySQL to ensure it's running with networking
echo '[+] Restarting mysql...'
mysqld_safe &
sleep 5
# Start Apache
echo '[+] Starting apache'
service apache2 start
# Keep container running
tail -f /var/log/apache2/* /var/log/mysql/* &
wait
