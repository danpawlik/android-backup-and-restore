#!/bin/bash

# At first, unpack TWRP backup by typing:
# NOTE: /data/data is where the application informations are located
# cd TWRP/BACKUPS/<ID>/<BACKUP DIR> ; for i in {0..5}; do tar xvf data.ext4.win00$i -C data ; done

BACKUP_DATA_DIR="/data/data"

# e.g.:
# APPS="authenticator2 pekao revolut securesms melodis uber yanosik whatsapp hbo fitness strava endomondo"
APPS=(REPLACE_ME)

if [ ! -d "$BACKUP_DATA_DIR" ]; then
    echo "Can not find backup data dir"
    exit 1
fi

if command -v adb; then
    echo "ADB bin detected. Let's start recovery"
else
    echo "ADB bin is not available! Exit"
    exit 1
fi

BACKUP_APPS=$(echo $APPS | sed 's/ /|/g')
ALL_APPS=$(adb shell ls /data/data | grep -iE "$BACKUP_APPS")
for app in $ALL_APPS;
do
    echo "Restoring app $app"
    id=$(adb shell ls -la /data/data/$app | awk '{print $3}' | sort -r | uniq -c | awk '{print $2}' | head -1)

    if [ -z "$id" ]; then
        echo "Can not get owner id of app $app"
        exit 1
    fi
    echo "App $app id is: $id"
    adb shell mv /data/data/$app /tmp/

    echo "Pushing data from backup dir"
    adb push $BACKUP_DATA_DIR/$app /data/data/

    echo "Setting owner"
    adb shell chown -R $id:$id /data/data/$app

    echo "Setting selinux for app"
    adb shell restorecon -Rv /data/data/$app
    id=""
done
