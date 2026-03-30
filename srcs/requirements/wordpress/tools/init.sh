#!/bin/bash
set -e

DB_USER_PASSWORD=$(cat /run/secrets/db_user_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_admin_password)

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
	
fi

PHP_FPM_VERSION=$(find /usr/sbin -name "php-fpm*" | head -1)
exec "${PHP_FPM_VERSION}" -F
