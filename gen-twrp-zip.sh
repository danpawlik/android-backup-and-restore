#!/bin/bash

APPS=("authenticator2" "pekao" "revolut" "securesms" "melodis" "uber" "yanosik" "whatsapp" "hbo" "fitness" "strava" "endomondo")

if command -v yum; then
    sudo yum install -y unzip
elif command -v apt; then
    sudo apt install -y unzip
fi

sed -i "s#REPLACE_ME#$APPS#g" tools/backup.sh

echo "Creating a custom backup and restore script..."
zip -r custom-backup-and-restore.zip META-INF tools
echo "Done!"
