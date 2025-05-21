#!/bin/bash

echo "Enter your database name:"
read db

echo "How many days?"
read end

date=$(date +"%Y-%m-%d")

for i in $(seq 0 $((end - 1))); do

  formatted_date=$(date -d "$date" +"%d/%m/%Y")

  echo "Traffic for date: $formatted_date"

  sudo apm traffic -s $db -f $formatted_date:00:00 -u $formatted_date:23:59

  date=$(date -d "$date - 1 day" +"%Y-%m-%d")

  sleep 1
done
