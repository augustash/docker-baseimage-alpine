#!/bin/bash

if [[ "$(ls /var/run/s6/container_environment/ | xargs)" == *"FILE__"* ]]; then
    for FILENAME in /var/run/s6/container_environment/*; do
        if [[ "${FILENAME##*/}" == "FILE__"* ]]; then
            SECRETFILE=$(cat "${FILENAME}")
            if [[ -f "${SECRETFILE}" ]]; then
                FILESTRIP=${FILENAME//FILE__/}
                cat "${SECRETFILE}" >"${FILESTRIP}"
                echo "[env-init] ${FILESTRIP##*/} set from ${FILENAME##*/}"
            else
                echo "[env-init] cannot find secret in ${FILENAME##*/}"
            fi
        fi
    done
fi
