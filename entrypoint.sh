#!/bin/sh

mysql_host="${DB_HOST:-mysql}"
mysql_port="${DB_PORT:-3306}"

until nc -z -v -w30 $mysql_host $mysql_port
do
  echo "Waiting for database connection..."
  sleep 2
done

# Create required database tables for Spotweb
sudo -E -u nobody php /var/www/spotweb/bin/upgrade-db.php

# Do it again because of some bug in spotweb :'(
sudo -E -u nobody php /var/www/spotweb/bin/upgrade-db.php --reset-password admin

# Create directory to log output
mkdir -p /data/logs/supervisor

# Start supervisord which spawns nginx and php-fpm5
exec /usr/bin/supervisord -n -c /etc/supervisord.conf