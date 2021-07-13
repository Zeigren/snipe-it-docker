FROM php:7.4-fpm-alpine

ARG BRANCH
ARG COMMIT
ARG DATE
ARG URL
ARG VERSION=5.1.8

LABEL org.label-schema.schema-version="1.0" \
    org.label-schema.build-date=$DATE \
    org.label-schema.vendor="Zeigren" \
    org.label-schema.name="zeigren/snipeit" \
    org.label-schema.url="https://hub.docker.com/r/zeigren/snipeit" \
    org.label-schema.version=$VERSION \
    org.label-schema.vcs-url=$URL \
    org.label-schema.vcs-branch=$BRANCH \
    org.label-schema.vcs-ref=$COMMIT

ENV SNIPE_IT_HOME="/var/www/html"
# https://snipe-it.readme.io/docs/requirements
RUN apk update \
    && apk add --no-cache libzip libpng freetype libjpeg-turbo fontconfig \
    ttf-freefont openldap-dev \
    && apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS libpng-dev freetype-dev libjpeg-turbo-dev libzip-dev \
    && docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg \
    && docker-php-ext-configure ldap \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-install bcmath gd ldap mysqli pdo_mysql opcache zip \
    && cd /var/www && curl -sS https://getcomposer.org/installer | php \
    && mv /var/www/composer.phar /usr/local/bin/composer \
    && SNIPE_IT_VERSION=$( echo $VERSION | grep -Eo [0-9.]+ | head -1 ) \
    && curl -o snipeit.tar.gz -fL "https://github.com/snipe/snipe-it/archive/v$SNIPE_IT_VERSION.tar.gz" \
    && tar -xzf snipeit.tar.gz --strip-components=1 -C $SNIPE_IT_HOME \
    && rm snipeit.tar.gz \
    && cd $SNIPE_IT_HOME && composer install --no-cache --no-dev \
    --optimize-autoloader \
    && echo "$SNIPE_IT_VERSION" > $SNIPE_IT_HOME/version \
    && chown -R www-data:www-data $SNIPE_IT_HOME \
    && apk del .build-deps \
    && rm -rf /root/.composer

COPY env_secrets_expand.sh docker-entrypoint.sh wait-for.sh /

RUN chmod +x /env_secrets_expand.sh \
    && chmod +x /docker-entrypoint.sh \
    && chmod +x /wait-for.sh

WORKDIR $SNIPE_IT_HOME

EXPOSE 9000

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["php-fpm", "-F"]
