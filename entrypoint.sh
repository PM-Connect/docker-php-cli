#!/bin/sh

echo ""
echo "  ____  __  __  ____"
echo " |  _ \|  \/  |/ ___|"
echo " | |_) | |\/| | |"
echo " |  __/| |  | | |___"
echo " |_|__ |_|__|_|\____|____  ____  ____"
echo " |  _ \| ____\ \   / / _ \|  _ \/ ___|"
echo " | | | |  _|  \ \ / / | | | |_) \___ \\"
echo " | |_| | |___  \ V /| |_| |  __/ ___) |"
echo " |____/|_____|  \_/  \___/|_|   |____/"
echo " Author: joseph@pmconnect.co.uk"
echo ""

set -e

if [ ! -z ${PHP_ENV_PATH+x} ]; then
  if [ -f "$PHP_ENV_PATH" ]; then
    echo "Adding PHP env variables..."
    cp "$PHP_ENV_PATH" /etc/php/7.2/fpm/env.d/env
  fi
fi

if [ ! -z ${PHP_UPLOAD_SIZE_MAX_MB+x} ]; then
  echo "Changing max upload and post size..."
  sed -ri "s#post_max_size=[0-9]+M#post_max_size=${PHP_UPLOAD_SIZE_MAX_MB}M#g" /usr/local/etc/php/php.ini
  sed -ri "s#upload_max_filesize=[0-9]+M#upload_max_filesize=${PHP_UPLOAD_SIZE_MAX_MB}M#g" /usr/local/etc/php/php.ini
  sed -ri "s#client_max_body_size [0-9]+m;#client_max_body_size ${PHP_UPLOAD_SIZE_MAX_MB}m;#g" /etc/nginx/sites-available/site.conf
fi

if [ ! -z ${PHP_MEMORY_LIMIT+x} ]; then
  echo "Setting php memory limit..."
  sed -ri "s#memory_limit = [0-9]+M#memory_limit = ${PHP_MEMORY_LIMIT}M#g" /usr/local/etc/php/php.ini
fi

if [ ! -z ${DEPLOYMENT_SCRIPT_PATH+x} ]; then
  if [ -f "$DEPLOYMENT_SCRIPT_PATH" ]; then
    echo "Making deployment up script executable..."
    chmod +x "$DEPLOYMENT_SCRIPT_PATH"
    bash "$DEPLOYMENT_SCRIPT_PATH"
  fi
fi

echo "Initiating command \"$@\""

echo ""

exec "$@"
