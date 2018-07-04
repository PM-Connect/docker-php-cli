FROM php:7.2-cli-alpine

RUN apk --no-cache update && apk --no-cache add shadow bash libmcrypt-dev

COPY ./php.ini /usr/local/etc/php/php.ini

RUN mkdir -p /var/app && \
    chown -R www-data:www-data /var/app && \
    mkdir -p /etc/php/7.2/fpm/env.d && \
    touch /etc/php/7.2/fpm/env.d/docker

COPY ./startup.php /var/app/public/index.php

COPY ./entrypoint.sh /entrypoint.sh

RUN chown root /entrypoint.sh && chmod +x /entrypoint.sh

WORKDIR /var/app

ENTRYPOINT ["/entrypoint.sh"]

CMD ["php", "public/index.php"]
