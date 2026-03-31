#!/bin/bash
set -e

FTP_USER_PASSWORD=$(cat /run/secrets/ftp_user_password)

mkdir -p /home/ftpusers

# useradd -m ${FTP_USER} || true && echo "${FTP_USER}:${FTP_USER_PASSWORD}" | chpasswd

if ! id "$FTP_USER" >/dev/null 2>&1; then
    useradd -m "$FTP_USER"
fi

echo "${FTP_USER}:${FTP_USER_PASSWORD}" | chpasswd

echo "starting FTP"

# exec pure-ftpd -E -R -c 50 --passiveportrange 30000:30009
exec pure-ftpd -E -R -C 5 --passiveportrange 30000:30009



