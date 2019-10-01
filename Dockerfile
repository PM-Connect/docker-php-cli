FROM php:7.2-cli-alpine

ARG PROJECT_DIR='/var/app'
ENV PROJECT_DIR=$PROJECT_DIR

COPY ./php.ini.template ./startup.php ./entrypoint.sh /ops/files/

RUN apk --no-cache update && \
    apk --no-cache add gettext shadow bash libmcrypt-dev icu-dev && \
    docker-php-ext-install opcache intl && \
    mkdir -p /var/app/public && \
    cp /ops/files/startup.php /var/app/public/index.php && \
    cp /ops/files/entrypoint.sh /entrypoint.sh && \
    chown -R www-data:www-data ${PROJECT_DIR} && \
    mkdir -p /etc/php/7.2/fpm/env.d && \
    touch /etc/php/7.2/fpm/env.d/docker && \
    chown root /entrypoint.sh && \
    chmod +x /entrypoint.sh

WORKDIR ${PROJECT_DIR}

ENTRYPOINT ["/entrypoint.sh"]

CMD ["php", "public/index.php"]
