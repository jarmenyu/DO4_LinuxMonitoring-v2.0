#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Enter only 1 param"
    exit 1
elif [[ ! $1 =~ ^[1-4]$ ]]; then 
    echo "Enter 1 digit from 1 to 4"
    exit 1
fi

sort_by_response() {
    goaccess $1 --sort-panel="STATUS_CODES,BY_DATA,ASC" --log-format=COMBINED -a -o rep1.html
}

sort_by_unique_ip() {
    goaccess $1 --sort-panel="HOSTS,BY_HITS,ASK" --log-format=COMBINED -a -o rep2.html
}

sort_by_error_response() {
    awk '$9 ~ /^4[0-9][0-9]$/ || $9 ~ /^5[0-9][0-9]$/' $1 | goaccess - -o rep3.html
}

sort_by_unique_ip_in_error_responses() {
    awk '$9 ~ /^4[0-9][0-9]$/ || $9 ~ /^5[0-9][0-9]$/' $1 | goaccess - \
    --sort-panel="HOSTS,BY_HITS,ASK" \
    --enable-panel="HOSTS" \
    --ignore-panel="STATUS_CODES" \
    --ignore-panel="REFERRERS" \
    --ignore-panel="REFERRING_SITES" \
    --ignore-panel="KEYPHRASES" \
    --ignore-panel="VIRTUAL_HOSTS" \
    --ignore-panel="VISITORS" \
    --ignore-panel="BROWSERS" \
    --ignore-panel="OS" \
    --ignore-panel="VISIT_TIMES" \
    --ignore-panel="NOT_FOUND" \
    --ignore-panel="REQUESTS_STATIC" \
    --ignore-panel="REQUESTS" \
    --ignore-panel="TLS_TYPE" \
    --ignore-panel="MIME_TYPE" \
    --ignore-panel="GEO_LOCATION" \
    --ignore-panel="CACHE_STATUS" \
    --ignore-panel="REMOTE_USER" \
    -o rep4.html
}

main_loop() {
    method=$1
    cat ../04/*.log > combined.log

    case $method in
        1)
            sort_by_response "combined.log" ;;
        2) 
            sort_by_unique_ip "combined.log" ;;
        3)
            sort_by_error_response "combined.log" ;;
        4)
            sort_by_unique_ip_in_error_responses "combined.log" ;;
        *)
            echo "fmlsdflk" ;;
    esac
}

main_loop $1