#!/bin/bash
set -e

DB_USER_PASSWORD=$(cat /run/secrets/db_user_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

WP_PATH="/var/www/html"
mkdir -p "${WP_PATH}"

if [ ! -f  "${WP_PATH}/wp-config.php" ]; then

	wp core download \
		--path="${WP_PATH}" \
		--allow-root
	
	wp config create \
		--path="${WP_PATH}" \
		--dbname="${MYSQL_DATABASE}" \
		--dbuser="${MYSQL_USER}" \
		--dbpass="${DB_USER_PASSWORD}" \
		--dbhost="${WP_DB_HOST}:3306" \
		--allow-root
	
	wp core install \
		--path="${WP_PATH}" \
		--url="https://${DOMAIN_NAME}" \
		--title="${WP_TITLE}" \
		--admin_user="${WP_ADMIN_USER}" \
		--admin_password="${WP_ADMIN_PASSWORD}" \
		--admin_email="${WP_ADMIN_EMAIL}" \
		--allow-root
	
	wp user create \
		--path="${WP_PATH}" \
		"${WP_USER}" "${WP_USER_EMAIL}" \
		--role=author \
		--user_pass="${WP_USER_PASSWORD}" \
		--allow-root

	# redis
	wp config set WP_REDIS_HOST "redis" --path="${WP_PATH}" --allow-root
	wp config set WP_REDIS_PORT "6379" --path="${WP_PATH}" --allow-root
	wp plugin install redis-cache --activate --path="${WP_PATH}" --allow-root
	wp redis enable --path="${WP_PATH}" --allow-root
	
fi

chown -R www-data:www-data "${WP_PATH}"
chmod -R 755 "${WP_PATH}"
chmod -R 775 "${WP_PATH}/wp-content"

sed -i 's|listen = /run/php/.*|listen = 0.0.0.0:9000|' \
    /etc/php/*/fpm/pool.d/www.conf

PHP_FPM_VERSION=$(find /usr/sbin -name "php-fpm*" | head -1)
exec "${PHP_FPM_VERSION}" -F
