#!/bin/bash

echo "Write the database name: "

read dbname

/var/cw/scripts/bash/duplicity_restore.sh --src $dbname -c

echo "Write the date of the backup: "

read bkp_res_date

bkp_date=$(date -d "$bkp_res_date" +"%Y-%m-%dT%H:%M:%S")

echo "Write the path of the directory with public_html: "

read path

 source /root/.duplicity && duplicity restore --no-encryption --no-print-statistics --s3-use-new-style -v 4 -t "$bkp_date" --file-to-restore public_html/$path $(awk -F'[="]' '/S3_url/ {print $3}' /root/.duplicity)/apps/$dbname downloaded-backup

 rm -- "$0"
