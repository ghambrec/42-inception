#!/bin/bash
set -e

FTP_USER_PASSWORD=$(cat /run/secrets/ftp_user_password)

if ! id "$FTP_USER" >/dev/null 2>&1; then
    useradd -m -d /home/wordpress -G www-data "${FTP_USER}"
else
	usermod -aG www-data "${FTP_USER}"
fi

echo "${FTP_USER}:${FTP_USER_PASSWORD}" | chpasswd

exec pure-ftpd /etc/pure-ftpd/pure-ftpd.conf
