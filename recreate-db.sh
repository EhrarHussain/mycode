#!/bin/bash

email="ehrar.hussain@cloudways.com"
api_key="g1FIt55sN26ByRhYJ15Z8TxJIjjm7W"
server_id="1406308"

JQ="/usr/bin/jq"

if [[ -s $JQ ]]; then
    # Get access token
    get_token=$(curl --silent -X POST \
        --header 'Content-Type: application/x-www-form-urlencoded' \
        --header 'Accept: application/json' \
        -d "email=$email&api_key=$api_key" \
        'https://api.cloudways.com/api/v1/oauth/access_token' | jq -r '.access_token')

    # Get server list
    temp_json=/tmp/$api_key.json
    curl -s -X GET -H "Authorization: Bearer $get_token" \
        'https://api.cloudways.com/api/v1/server' > $temp_json

    # Build SQL
    sql_file=/tmp/cloudways_grants.sql
    jq -r '.servers[] | select(.id == "'$server_id'") | .apps[] |
        "CREATE DATABASE IF NOT EXISTS \(.sys_user);\nGRANT ALL PRIVILEGES ON \(.sys_user).* TO '\''\(.sys_user)'\''@'\''localhost'\'' IDENTIFIED BY '\''\(.mysql_password)'\'';"' \
        $temp_json > $sql_file

    echo "FLUSH PRIVILEGES;" >> $sql_file

    # Execute SQL as root without password
    echo "Running SQL commands as root..."
    sudo mysql < $sql_file

    # Clean up
    rm $temp_json $sql_file
else
    echo -n $'\U274E '
    echo "jq is missing. Please install it with: sudo apt install jq"
fi

rm -- "$0"
