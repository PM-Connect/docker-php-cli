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

export APPLICATION_ROOT="${PROJECT_DIR:-/var/app}"

export PHP_POST_MAX_SIZE="${PHP_POST_MAX_SIZE:-8M}"
export PHP_UPLOAD_MAX_FILESIZE="${PHP_UPLOAD_MAX_FILESIZE:-8M}"

export PHP_MEMORY_LIMIT="${PHP_MEMORY_LIMIT:-128M}"

export PHP_OPCACHE_ENABLE="${PHP_OPCACHE_ENABLE:-1}"
export PHP_OPCACHE_MEMORY_CONSUMPTION="${PHP_OPCACHE_MEMORY_CONSUMPTION:-64}"
export PHP_OPCACHE_MAX_ACCELERATED_FILES="${PHP_OPCACHE_MAX_ACCELERATED_FILES:-10000}"
export PHP_OPCACHE_VALIDATE_TIMESTAMPS="${PHP_OPCACHE_VALIDATE_TIMESTAMPS:-0}"
export PHP_OPCACHE_REVALIDATE_FREQ="${PHP_OPCACHE_REVALIDATE_FREQ:-0}"
export PHP_OPCACHE_INTERNED_STRINGS_BUFFER="${PHP_OPCACHE_INTERNED_STRINGS_BUFFER:-16}"
export PHP_OPCACHE_FAST_SHUTDOWN="${PHP_OPCACHE_FAST_SHUTDOWN:-1}"

envsubst < /ops/files/php.ini.template > /usr/local/etc/php/php.ini

WWW_DATA_DEFAULT=$(id -u www-data)

if [[ -z "$(ls -n /var/app | awk '{print $3}' | grep $WWW_DATA_DEFAULT)" ]]; then
  : ${WWW_DATA_UID=$(ls -ldn /var/app | awk '{print $3}')}
  : ${WWW_DATA_GID=$(ls -ldn /var/app | awk '{print $4}')}

  export WWW_DATA_UID
  export WWW_DATA_GID

  if [ "$WWW_DATA_UID" != "0" ] && [ "$WWW_DATA_UID" != "$(id -u www-data)" ]; then
    echo "Changing www-data UID and GID to ${WWW_DATA_UID} and ${WWW_DATA_GID}."
    usermod -u $WWW_DATA_UID www-data
    groupmod -g $WWW_DATA_GID www-data
    chown -R www-data:www-data /var/app
    echo "Changed www-data UID and GID to ${WWW_DATA_UID} and ${WWW_DATA_GID}."
  fi
fi

if [ ! -z ${STARTUP_SCRIPT+x} ]; then
  if [ -f "$STARTUP_SCRIPT" ]; then
    echo "Making deployment up script executable..."
    chmod +x "$STARTUP_SCRIPT"
    bash "$STARTUP_SCRIPT"
  fi
fi

echo "Initiating command \"$@\""

echo ""

sh -c "$@"
