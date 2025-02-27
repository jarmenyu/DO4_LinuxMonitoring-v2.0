#!/bin/bash

path_necessary="$(pwd)/../02/info.log"


if [ $# -ne 1 ]; then
    echo "Print only 1 param"
    exit 1
elif [[ ! $1 =~ ^[1-3]$ ]]; then
    echo "Parameter id digit from 1 to 3"
    exit 1
fi


delete_by_logfile() {
    echo "delete_by_logfile start"

    grep "File path:" "$path_necessary" | awk '{print $3}' | xargs rm -f
    grep "Directory path:" "$path_necessary" | awk '{print $3}' | xargs rm -rf

    > "$path_necessary"
    # sudo rm -rf /var/snap/*


    echo "delete_by_logfile end"
}

delete_by_mask() {
    echo "delete_by_mask start"

    echo -e "Enter mask like azzzz_180225:\n"
    read mask

    sudo find / -type d -name "$mask" -exec rm -rf {} \; 2>/dev/null
18/02/25 17:08:51
    echo "delete_by_mask end"
}

delete_by_date_and_time() {
    echo "delete_by_date_and_time start"

    echo -e "Enter start and end time accurate to the minute:"
    echo "Enter start time (YYYY-MM-DD HH:MM:SS):"
    read start
    echo "Enter end time (YYYY-MM-DD HH:MM:SS):"
    read end

    sudo find / -type f -newermt "$start" ! -newermt "$end" -exec rm -f {} \; 2>/dev/null
    sudo find / -type d -empty -delete 2>/dev/null

    echo "delete_by_date_and_time end"
}

main_loop() {
    method=$1

    case $method in 
        1)
            delete_by_logfile ;;
        2)
            delete_by_date_and_time ;;
        3)
            delete_by_mask ;;
        *)
            echo "AYE" ;;
    esac
}

main_loop $1


