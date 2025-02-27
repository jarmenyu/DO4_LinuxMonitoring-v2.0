#!/bin/bash

time_start=$(date +%s)
path_necessary=$(pwd)/info.log

if [ $# -ne 3 ]; then
    echo "Enter 3 parameters"
    exit 1
elif [[ ! "$1" =~ ^[A-Za-z]{1,7}$ ]]; then
    echo "First parameter must not with digits and length must be less or equal 7 characters"
    exit 1
elif [[ ! "$2" =~ ^[A-Za-z]{1,7}\.[A-Za-z]{1,3}$ ]]; then
    echo "Second parameter must not with digits, length must be less or equal 7 characters
    and length must be less or equal 3 characters for the extension"
    exit 1
elif [[ ! $3 =~ (^[1-9][0-9]?|100)Mb$ ]]; then
    echo "file size must be less or equal than 100 kilobyte"
    exit 1
fi

get_size() {
    size=$1
    count=""

    for (( i=0; i < ${#size}; i++ )); do
        if [[ ${1:$i:1} =~ [0-9] ]]; then
            count+=${1:$i:1}
        fi
    done
    echo "$count"
}

generate_name() {
    local charset="$1"   
    local length="$2"  
    local name=""        
    local index=0      
    local remaining_length=$length  
    local used_length=0    

    while [[ ${#name} -lt $length ]]; do
        local max_repeat=$((remaining_length - (${#charset} - index - 1)))

        if [[ $max_repeat -lt 1 ]]; then
            max_repeat=1
        fi

        if [[ $max_repeat -gt $remaining_length ]]; then
            max_repeat=$remaining_length
        fi

        local repeat=$((1 + RANDOM % max_repeat))

        local j=0
        while [[ $j -lt $repeat && ${#name} -lt $length ]]; do
            name+="${charset:$index:1}"
            ((j++))
            ((used_length++))
        done

        ((index++))

        if [[ $index -ge ${#charset} ]]; then
            break
        fi

        remaining_length=$((length - used_length))
    done

    echo "$name"
}

create_logfile() {
    dir_path="$1"
    dir_date="$2"
    file_path="$3"
    file_date="$4"
    file_size="$5"
    echo "Directory path: $dir_path" >> $path_necessary
    echo "Directory date: $dir_date" >> $path_necessary
    echo "File path: $file_path" >> $path_necessary
    echo "File date: $file_date" >> $path_necessary
    echo "File size: $file_size" >> $path_necessary
    echo "----------------------" >> $path_necessary
}

check_memory() {
    local free_space=$(df --output=avail / | tail -n 1)
    if [[ $free_space -lt $((1024*1024)) ]]; then
        echo "Directory is full" >&2
        exit 1
    fi
}


generate_unique_folder_name() {
    local path="$1"
    local charset="$2"
    local max_attempts=100
    local attempt=0
    local folder_name=""
    
    while (( attempt < max_attempts )); do
        folder_name=$(generate_name "$charset" 7)

        while [[ ${#folder_name} -lt 5 ]]; do
            folder_name+="${folder_name: -1}"
        done
        
        local folder="${folder_name}_$(date +%d%m%y)"
        if [[ ! -d "$path/$folder" ]]; then
            echo "$folder"
            return 0
        fi
        ((attempt++))
    done

    return 1
}

create_folder() {
    local path="$1"
    local folder_name="$2"
    local arr=()
    mkdir -p "$path/$folder_name"
    echo "$path/$folder_name"
}

generate_unique_file_name() {
    local dir="$1"
    local charset="$2"
    local extension="$3"
    local max_attempts=100
    local attempt=0
    local file_name=""
    
    while (( attempt < max_attempts )); do
        file_name="$(generate_name "$charset" 7).$extension"
        if [[ ! -f "$dir/$file_name" ]]; then
            echo "$file_name"
            return 0
        fi
        ((attempt++))
    done

    return 1
}

create_file_in_folder() {
    local dir="$1"
    local file_name="$2"
    local size=$3
    local numb_size=$(get_size $size)
    dd if=/dev/zero of="$dir/$file_name" bs=1M count="$numb_size" &>/dev/null
}

trap 'end_time=$(date +%s);
      duration=$((end_time - time_start));
      echo "Time start from: $time_start" >> "$path_necessary";
      echo "Time end from: $end_time" >> "$path_necessary";
      echo "Program execution time: $duration seconds" >> "$path_necessary";' EXIT

main_loop() {
    local folder_charset="$1"
    local file_template="$2"
    local file_size="$3"
    local base_path=$(find / -type d -writable 2>/dev/null | grep -v -E '/bin|/sbin|/proc|/dev|/sys' | shuf -n 1)

    for (( i = 0; i < 100; i++ )); do
        check_memory
        local folder_name
        folder_name=$(generate_unique_folder_name "$base_path" "$folder_charset")
        if [[ $? -ne 0 ]]; then
            continue
        fi


        local folder_date=$(date +'%d/%m/%y %H:%M:%S')
        local folder_path
        folder_path=$(create_folder "$base_path" "$folder_name")


        local file_arr=($(echo "$file_template" | awk -F'.' '{print $1, $2}'))
        local file_name_charset="${file_arr[0]}"
        local file_extension="${file_arr[1]}"

        local num_files=$((RANDOM % 100))

        for (( j = 0; j < $num_files; j++ )); do
            check_memory

            local file_name
            file_name=$(generate_unique_file_name "$folder_path" "$file_name_charset" "$file_extension")
            if [[ $? -ne 0 ]]; then
                continue
            fi

            local file_date=$(date +'%d/%m/%y %H:%M:%S')

            create_file_in_folder "$folder_path" "$file_name" "$file_size"
            create_logfile "$folder_path" "$folder_date" "$folder_path/$file_name" "$file_date" "$file_size"
        done
    done
    time_end=$(date +%s)
    time_difference=$((time_end - $time_start)) 
    echo "Time start from: $time_start" >> $path_necessary
    echo "Time end from: $time_end" >> $path_necessary
    echo "Program execution time: $time_difference" >> $path_necessary
}

main_loop "$1" "$2" "$3"
