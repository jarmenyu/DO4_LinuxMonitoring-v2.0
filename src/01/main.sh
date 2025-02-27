#!/bin/bash

source ./functions.sh

if [ $# -ne 6 ]; then
    echo "Enter 6 parameters"
    exit 1
elif [[ ! -d $1 ]]; then
    echo "directory does not exist"
elif [[ ! $2 =~ ^[1-9][0-9]*$ ]]; then
    echo "number of subfolders must be a numeric value"
    exit 1
elif [[ ! "$3" =~ ^[A-Za-z]{1,7}$ ]]; then
    echo "Third parameter must not with digits and length must be less or equal 7 characters"
    exit 1
elif [[ ! $4 =~ ^[1-9][0-9]*$ ]]; then
    echo "number of files must be a numeric value"
    exit 1
elif [[ ! "$5" =~ ^[A-Za-z]{1,7}\.[A-Za-z]{1,3}$ ]]; then
    echo "Fifth parameter must not with digits, length must be less or equal 7 characters
    and length must be less or equal 3 characters for the extension"
    exit 1
elif [[ ! $6 =~ (^[1-9][0-9]?|100)kb$ ]]; then
    echo "file size must be less or equal than 100 kilobyte"
    exit 1
fi

main_loop() {
    local base_path="$1"
    local num_folders="$2"
    local folder_charset="$3"
    local num_files="$4"
    local file_template="$5"
    local file_size="$6"

    for (( i = 0; i < num_folders; i++ )); do
        local folder_name
        folder_name=$(generate_unique_folder_name "$base_path" "$folder_charset") || continue

        local folder_date=$(date +%d/%m/%y)
        local folder_path
        folder_path=$(create_folder "$base_path" "$folder_name")


        local file_arr=($(echo "$file_template" | awk -F'.' '{print $1, $2}'))
        local file_name_charset="${file_arr[0]}"
        local file_extension="${file_arr[1]}"

        for (( j = 0; j < num_files; j++ )); do
            check_memory $base_path

            local file_name
            file_name=$(generate_unique_file_name "$folder_path" "$file_name_charset" "$file_extension") || continue
            local file_date=$(date +%d/%m/%y)

            create_file_in_folder "$folder_path" "$file_name" "$file_size"
            create_file $base_path $folder_path $folder_date "$folder_path/$file_name" $file_date $file_size
        done
    done
}

main_loop "$1" "$2" "$3" "$4" "$5" "$6"