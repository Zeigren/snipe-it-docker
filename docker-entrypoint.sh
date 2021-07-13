#!/bin/sh

source /env_secrets_expand.sh

set -e

# https://github.com/snipe/snipe-it/blob/master/docker/docker-entrypoint.sh
# https://github.com/snipe/snipe-it/blob/master/.env.docker

# Generate new app key if none is provided
if [ -z "$APP_KEY" ]; then
  echo "Please re-run this container with an environment variable APP_KEY"
  echo "An example APP_KEY you could use is: "
  php artisan key:generate --show
  exit
fi

cat >"$SNIPE_IT_HOME/.env" <<EOF
# --------------------------------------------
# REQUIRED: DB SETUP
# --------------------------------------------
# MYSQL_DATABASE=${MYSQL_DATABASE:-snipeit}
# MYSQL_USER=${MYSQL_USER:-snipeit}
# MYSQL_PASSWORD=${MYSQL_PASSWORD:-CHANGEME}
# MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-CHANGEME}
# --------------------------------------------
# REQUIRED: BASIC APP SETTINGS
# --------------------------------------------
APP_ENV=${APP_ENV:-production}
APP_DEBUG=${APP_DEBUG:-false}
APP_KEY=${APP_KEY:-base64:3ilviXqB9u6DX1NRcyWGJ+sjySF+H18CPDGb3+IVwMQ=}
APP_URL=${APP_URL:-http://localhost:9000}
APP_TIMEZONE=${APP_TIMEZONE:-'UTC'}
APP_LOCALE=${APP_LOCALE:-en}
MAX_RESULTS=${MAX_RESULTS:-500}

# --------------------------------------------
# REQUIRED: UPLOADED FILE STORAGE SETTINGS
# --------------------------------------------
PRIVATE_FILESYSTEM_DISK=${PRIVATE_FILESYSTEM_DISK:-local}
PUBLIC_FILESYSTEM_DISK=${PUBLIC_FILESYSTEM_DISK:-local_public}

# --------------------------------------------
# REQUIRED: DATABASE SETTINGS
# --------------------------------------------
DB_CONNECTION=${DB_CONNECTION:-mysql}
DB_HOST=${DB_HOST:-mariadb}
DB_DATABASE=${DB_DATABASE:-snipeit}
DB_USERNAME=${DB_USERNAME:-snipeit}
DB_PASSWORD=${DB_PASSWORD:-CHANGEME}
DB_PREFIX=${DB_PREFIX:-null}
DB_DUMP_PATH=${DB_DUMP_PATH:-'/usr/bin'}
DB_CHARSET=${DB_CHARSET:-utf8mb4}
DB_COLLATION=${DB_COLLATION:-utf8mb4_unicode_ci}

# --------------------------------------------
# OPTIONAL: SSL DATABASE SETTINGS
# --------------------------------------------
DB_SSL=${DB_SSL:-false}
DB_SSL_IS_PAAS=${DB_SSL_IS_PAAS:-false}
DB_SSL_KEY_PATH=${DB_SSL_KEY_PATH:-null}
DB_SSL_CERT_PATH=${DB_SSL_CERT_PATH:-null}
DB_SSL_CA_PATH=${DB_SSL_CA_PATH:-null}
DB_SSL_CIPHER=${DB_SSL_CIPHER:-null}

# --------------------------------------------
# REQUIRED: OUTGOING MAIL SERVER SETTINGS
# --------------------------------------------
MAIL_DRIVER=${MAIL_DRIVER:-smtp}
MAIL_HOST=${MAIL_HOST:-mailhog}
MAIL_PORT=${MAIL_PORT:-1025}
MAIL_USERNAME=${MAIL_USERNAME:-null}
MAIL_PASSWORD=${MAIL_PASSWORD:-null}
MAIL_ENCRYPTION=${MAIL_ENCRYPTION:-null}
MAIL_FROM_ADDR=${MAIL_FROM_ADDR:-you@example.com}
MAIL_FROM_NAME=${MAIL_FROM_NAME:-'Snipe-IT'}
MAIL_REPLYTO_ADDR=${MAIL_REPLYTO_ADDR:-you@example.com}
MAIL_REPLYTO_NAME=${MAIL_REPLYTO_NAME:-'Snipe-IT'}
MAIL_AUTO_EMBED_METHOD=${MAIL_AUTO_EMBED_METHOD:-'attachment'}

# --------------------------------------------
# REQUIRED: IMAGE LIBRARY
# This should be gd or imagick
# --------------------------------------------
IMAGE_LIB=${IMAGE_LIB:-gd}

# --------------------------------------------
# OPTIONAL: BACKUP SETTINGS
# --------------------------------------------
MAIL_BACKUP_NOTIFICATION_DRIVER=${MAIL_BACKUP_NOTIFICATION_DRIVER:-null}
MAIL_BACKUP_NOTIFICATION_ADDRESS=${MAIL_BACKUP_NOTIFICATION_ADDRESS:-null}
BACKUP_ENV=${BACKUP_ENV:-true}

# --------------------------------------------
# OPTIONAL: SESSION SETTINGS
# --------------------------------------------
SESSION_LIFETIME=${SESSION_LIFETIME:-12000}
EXPIRE_ON_CLOSE=${EXPIRE_ON_CLOSE:-false}
ENCRYPT=${ENCRYPT:-false}
COOKIE_NAME=${COOKIE_NAME:-snipeit_session}
COOKIE_DOMAIN=${COOKIE_DOMAIN:-null}
SECURE_COOKIES=${SECURE_COOKIES:-true}
API_TOKEN_EXPIRATION_YEARS=${API_TOKEN_EXPIRATION_YEARS:-40}

# --------------------------------------------
# OPTIONAL: SECURITY HEADER SETTINGS
# --------------------------------------------
APP_TRUSTED_PROXIES=${APP_TRUSTED_PROXIES:-10.0.0.0/8,172.16.0.0/12,192.168.0.0/16}
ALLOW_IFRAMING=${ALLOW_IFRAMING:-false}
REFERRER_POLICY=${REFERRER_POLICY:-same-origin}
ENABLE_CSP=${ENABLE_CSP:-false}
CORS_ALLOWED_ORIGINS=${CORS_ALLOWED_ORIGINS:-null}
ENABLE_HSTS=${ENABLE_HSTS:-false}

# --------------------------------------------
# OPTIONAL: CACHE SETTINGS
# --------------------------------------------
CACHE_DRIVER=${CACHE_DRIVER:-file}
SESSION_DRIVER=${SESSION_DRIVER:-file}
QUEUE_DRIVER=${QUEUE_DRIVER:-sync}
CACHE_PREFIX=${CACHE_PREFIX:-snipeit}

# --------------------------------------------
# OPTIONAL: REDIS SETTINGS
# --------------------------------------------
REDIS_HOST=${REDIS_HOST:-redis}
REDIS_PASSWORD=${REDIS_PASSWORD:-null}
REDIS_PORT=${REDIS_PORT:-6379}

# --------------------------------------------
# OPTIONAL: MEMCACHED SETTINGS
# --------------------------------------------
MEMCACHED_HOST=${MEMCACHED_HOST:-null}
MEMCACHED_PORT=${MEMCACHED_PORT:-null}

# --------------------------------------------
# OPTIONAL: PUBLIC S3 Settings
# --------------------------------------------
PUBLIC_AWS_SECRET_ACCESS_KEY=${PUBLIC_AWS_SECRET_ACCESS_KEY:-null}
PUBLIC_AWS_ACCESS_KEY_ID=${PUBLIC_AWS_ACCESS_KEY_ID:-null}
PUBLIC_AWS_DEFAULT_REGION=${PUBLIC_AWS_DEFAULT_REGION:-null}
PUBLIC_AWS_BUCKET=${PUBLIC_AWS_BUCKET:-null}
PUBLIC_AWS_URL=${PUBLIC_AWS_URL:-null}
PUBLIC_AWS_BUCKET_ROOT=${PUBLIC_AWS_BUCKET_ROOT:-null}

# --------------------------------------------
# OPTIONAL: PRIVATE S3 Settings
# --------------------------------------------
PRIVATE_AWS_ACCESS_KEY_ID=${PRIVATE_AWS_ACCESS_KEY_ID:-null}
PRIVATE_AWS_SECRET_ACCESS_KEY=${PRIVATE_AWS_SECRET_ACCESS_KEY:-null}
PRIVATE_AWS_DEFAULT_REGION=${PRIVATE_AWS_DEFAULT_REGION:-null}
PRIVATE_AWS_BUCKET=${PRIVATE_AWS_BUCKET:-null}
PRIVATE_AWS_URL=${PRIVATE_AWS_URL:-null}
PRIVATE_AWS_BUCKET_ROOT=${PRIVATE_AWS_BUCKET_ROOT:-null}

# --------------------------------------------
# OPTIONAL: LOGIN THROTTLING
# --------------------------------------------
LOGIN_MAX_ATTEMPTS=${LOGIN_MAX_ATTEMPTS:-5}
LOGIN_LOCKOUT_DURATION=${LOGIN_LOCKOUT_DURATION:-60}
RESET_PASSWORD_LINK_EXPIRES=${RESET_PASSWORD_LINK_EXPIRES:-900}

# --------------------------------------------
# OPTIONAL: MISC
# --------------------------------------------
APP_LOG=${APP_LOG:-stderr}
APP_LOG_MAX_FILES=${APP_LOG_MAX_FILES:-10}
APP_LOCKED=${APP_LOCKED:-false}
APP_CIPHER=${APP_CIPHER:-AES-256-CBC}
GOOGLE_MAPS_API=${GOOGLE_MAPS_API:-}
LDAP_MEM_LIM=${LDAP_MEM_LIM:-500M}
LDAP_TIME_LIM=${LDAP_TIME_LIM:-600}
EOF

cat >"/usr/local/etc/php/php.ini" <<EOF
post_max_size = ${POST_MAX_SIZE:-10M}
upload_max_filesize = ${UPLOAD_MAX_FILESIZE:-10M}
memory_limit = ${MEMORY_LIMIT:-1024M}
expose_php = ${EXPOSE_PHP:-off}
cgi.fix_pathinfo = ${CGIFIX_PATHINFO:-0}
EOF

cat >"/usr/local/etc/php/conf.d/opcache.ini" <<EOF
opcache.memory_consumption=${OPCACHE_MEMORY_CONSUMPTION:-64}
opcache.max_accelerated_files=${OPCACHE_MAX_ACCELERATED_FILES:-4000}
opcache.revalidate_freq=${OPCACHE_REVALIDATE_FREQ:-60}
opcache.fast_shutdown=${OPCACHE_FAST_SHUTDOWN:-1}
opcache.enable_cli=${OPCACHE_ENABLE_CLI:-1}
opcache.validate_timestamps=${OPCACHE_VALIDATE_TIMESTAMPS:-0}
EOF

# Set PHP-FPM conf
sed -i "s/pm =.*/pm = ${FPM_PM:-dynamic}/" /usr/local/etc/php-fpm.d/www.conf
sed -i "s/pm.max_children =.*/pm.max_children = ${FPM_MAX_CHILDREN:-5}/" /usr/local/etc/php-fpm.d/www.conf
sed -i "s/pm.start_servers =.*/pm.start_servers = ${FPM_START_SERVERS:-2}/" /usr/local/etc/php-fpm.d/www.conf
sed -i "s/pm.min_spare_servers =.*/pm.min_spare_servers = ${FPM_MIN_SPARE:-1}/" /usr/local/etc/php-fpm.d/www.conf
sed -i "s/pm.max_spare_servers =.*/pm.max_spare_servers = ${FPM_MAX_SPARE:-3}/" /usr/local/etc/php-fpm.d/www.conf

echo "Test connection to ${DB_HOST:-mariadb}"

/wait-for.sh ${DB_HOST:-mariadb}:3306 -- echo 'Success!'

echo "Give ${DB_HOST:-mariadb} a few seconds to warm up"

sleep 5s

export SNIPE_IT_VERSION="$(grep -Eo '[0-9.]+' ${SNIPE_IT_HOME}/version)"
mkdir -p /var/www/snipeit
curl -L -o /var/www/snipeit/snipeit.tar.gz https://github.com/snipe/snipe-it/archive/v$SNIPE_IT_VERSION.tar.gz
tar --strip-components=1 -C /var/www/snipeit -xzf /var/www/snipeit/snipeit.tar.gz
cp -rf /var/www/snipeit/public ${SNIPE_IT_HOME}
rm -rf /var/www/snipeit

chown -R www-data:www-data \
  $SNIPE_IT_HOME/public/uploads \
  $SNIPE_IT_HOME/storage

# If the Oauth DB files are not present copy the vendor files over to the db migrations
if [ ! -f "/var/www/html/database/migrations/*create_oauth*" ]; then
  cp -a /var/www/html/vendor/laravel/passport/database/migrations/* /var/www/html/database/migrations/
fi

php artisan migrate --force
php artisan config:clear
php artisan config:cache

exec "$@"
