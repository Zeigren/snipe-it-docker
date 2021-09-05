FROM php:7.4-fpm-alpine

ARG DATE
ARG VERSION

LABEL org.opencontainers.image.created=$DATE \
    org.opencontainers.image.authors="Zeigren" \
    org.opencontainers.image.url="https://github.com/Zeigren/snipe-it-docker" \
    org.opencontainers.image.source="https://github.com/Zeigren/snipe-it-docker" \
    org.opencontainers.image.version=$VERSION \
    org.opencontainers.image.title="zeigren/snipe-it"

ENV SNIPE_IT_HOME="/var/www/snipeit"
# https://snipe-it.readme.io/docs/requirements
RUN apk update \
    && apk add --no-cache libzip libpng freetype libjpeg-turbo fontconfig \
    ttf-freefont openldap-dev libwebp \
    && apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS libpng-dev freetype-dev libjpeg-turbo-dev libzip-dev libwebp-dev \
    && docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-configure ldap \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-install bcmath gd ldap mysqli pdo_mysql opcache zip \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && cd /var/www && curl -sS https://getcomposer.org/installer | php \
    && mv /var/www/composer.phar /usr/local/bin/composer \
    && curl -sSL -o snipeit.tar.gz "https://github.com/snipe/snipe-it/archive/$VERSION.tar.gz" \
    && mkdir -p $SNIPE_IT_HOME $SNIPE_IT_HOME/tmp_public \
    && tar --strip-components=1 -C $SNIPE_IT_HOME -xf snipeit.tar.gz \
    && rm snipeit.tar.gz \
    && cd $SNIPE_IT_HOME && composer install --no-cache --no-dev --optimize-autoloader \
    && mv $SNIPE_IT_HOME/public/* $SNIPE_IT_HOME/tmp_public \
    && chown -R www-data:www-data $SNIPE_IT_HOME /usr/local/etc/php-fpm.d /usr/local/etc/php \
    && apk del .build-deps \
    && rm -rf /root/.composer

COPY env_secrets_expand.sh docker-entrypoint.sh wait-for.sh /

RUN chmod +x /env_secrets_expand.sh /docker-entrypoint.sh /wait-for.sh

USER www-data

VOLUME $SNIPE_IT_HOME/storage $SNIPE_IT_HOME/public

WORKDIR $SNIPE_IT_HOME

EXPOSE 9000

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["php-fpm", "-F"]
