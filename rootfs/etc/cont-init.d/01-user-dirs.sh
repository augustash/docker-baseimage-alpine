#!/usr/bin/with-contenv bash

chown "${PUID}:${PGID}" /backups
chown "${PUID}:${PGID}" /defaults
chown "${PUID}:${PGID}" /src
