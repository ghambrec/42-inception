#!/bin/bash
set -e

ADMIN_PASSWORD=$(cat /run/secrets/gitea_admin_password)
export GITEA_WORK_DIR=/var/lib/gitea

if [ ! -f /var/lib/gitea/data/gitea.db ]; then

    gosu git gitea web --config /etc/gitea/app.ini &
    GITEA_PID=$!

    until curl -s -o /dev/null -w '%{http_code}' http://localhost:3000 | grep -qv "000"; do
        sleep 2
    done

    gosu git gitea admin user create \
        --config /etc/gitea/app.ini \
        --username ${GITEA_ADMIN_USER} \
        --password ${ADMIN_PASSWORD} \
        --email admin@${DOMAIN_NAME} \
        --admin \
        --must-change-password=false

    kill $GITEA_PID
    wait $GITEA_PID 2>/dev/null
fi

exec gosu git gitea web --config /etc/gitea/app.ini
