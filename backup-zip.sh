#!/bin/bash

app_sys_user=$(basename "$(dirname "$PWD")")

mysqldump "$app_sys_user" > "${app_sys_user}.sql"

zip -r "backup-${app_sys_user}.zip" .

chown "$app_sys_user":www-data backup*

chmod 664 backup*

echo "Zip Created"

rm -- "$0"
