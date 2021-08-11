#!/usr/bin/env bash

chown www-data /var/www/ /var/www/var/log
chown -R www-data:www-data /var/www/
chmod -R 777 /var/www/

#SYMFONY_VERSION=${SYMFONY_VERSION:-5}
#NGINX_CONFIG=symfony$SYMFONY_VERSION

NGINX_CONFIG=site0

# Avoid to remove a bind mounted nginx config
NGINX_DEFAULT=/etc/nginx/sites-enabled/default
if ! mountpoint -q $NGINX_DEFAULT; then
  echo "Using default nginx config : $NGINX_CONFIG"
  rm $NGINX_DEFAULT
  ln -s /etc/nginx/sites-available/$NGINX_CONFIG.conf $NGINX_DEFAULT
fi

# Disable opcache optimisation for developpement
# Allow files to be reloaded when update without restarting fpm process
if [[ "$PERFORMANCE_OPTIM" = "false" ]]
then
  echo "Disable performance optimisation"
  echo > /etc/php/7.4/fpm/conf.d/99-symfony.ini
fi

exec /usr/bin/supervisord -n
