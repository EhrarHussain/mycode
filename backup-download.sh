#!/bin/bash

echo "Enter your database name:"
read db

echo "Select the type of backup:"

bkp_cat=("1. Web files & Database" "2. Web files only" "3. Database only")

for bkp_cat in "${bkp_cat[@]}"; do
echo $bkp_cat
done

read bkp_type

echo "Select the restore point:"

/var/cw/scripts/bash/duplicity_restore.sh --src $db -c

read bkp_res_date

bkp_date=$(date -d "$bkp_res_date" +"%Y-%m-%dT%H:%M:%S")

echo "Sit tight while your backup is preparing"

if [ "$bkp_type" -eq 1 ]; then
        /var/cw/scripts/bash/duplicity_restore.sh --src $db -r --dst . --time $bkp_date
elif [ "$bkp_type" -eq 2 ]; then
        /var/cw/scripts/bash/duplicity_restore.sh --src $db -w --dst . --time $bkp_date
elif [ "$bkp_type" -eq 3 ]; then
        /var/cw/scripts/bash/duplicity_restore.sh --src $db -d --dst . --time $bkp_date
else
        echo "Choose correct number"
fi

echo "Downloading finished"

rm -- "$0"
