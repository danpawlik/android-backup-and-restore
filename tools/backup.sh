#!/bin/bash

APPS=(REPLACE_ME)
BACKUP_PATH="/sdcard/TWRP/custom-backup"
BACKUP_NAME="app-data-$(date +'%Y%m%d_%H%M%S').tar.gz"

if [ -z "${APPS}" ]; then
    echo "No APPS provided!"
    exit 1
fi

if [ -z "${BACKUP_PATH}" ]; then
    echo "No BACKUP_PATH provided"
    exit 1
fi

if ! -d "${BACKUP_PATH}"; then
    mkdir -p "${BACKUP_PATH}"
fi

AVAILABLE_APPS=""
EXCLUDE=""
for APP in $APPS; do
    # Include all apps that contains such name
    for app_name in $(ls /data/data/ | grep -i "${APP}"); do
        AVAILABLE_APPS+="/data/data/$app_name "
        if [ -n "${app_name}" ]; then
            # skip compressing cache
            EXCLUDE+="--exclude=/data/data/$app_name/{cache,.cache} "
        fi
    done
done

tar czf "${BACKUP_PATH}/${BACKUP_NAME}" "${EXCLUDE}" "${AVAILABLE_APPS}"
