#!/bin/bash

app_sys_user=$(basename "$(dirname "$PWD")")

echo "Starting"

mysqldump "$app_sys_user" > "${app_sys_user}.sql"

zip -r "backup-${app_sys_user}.zip" . -x "backup-zip.sh"

chown "$app_sys_user":www-data backup*

chmod 664 backup*

rm "${app_sys_user}.sql"

echo "Zip Created"

rm -- "$0"
