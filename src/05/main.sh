#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Enter 1 parameter"
elif [[ ! $1 =~ ^[1-4]$ ]]; then
    echo "Enter 1 digit from 1 to 4"
fi


sort_by_response() {
    awk '{print}' $1 | sort -k9,9n
}

sort_by_unique_ip() {
    awk '{unique[$1]++} END {for (ip in unique) if (unique[ip] == 1) print ip}' $1 
}

sort_by_error_response() {
    awk '$9 ~ /^4[0-9][0-9]$/ || $9 ~ /^5[0-9][0-9]$/ {print $9}' $1 | sort -n
}

sort_by_unique_ip_in_error_responses() {
    awk '$9 ~ /^[45][0-9][0-9]$/ {unique[$1]++} END {for (ip in unique) if (unique[ip] == 1) print ip}' $1 | sort -n
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
            echo "AYE" ;;
    esac
} 

main_loop $1