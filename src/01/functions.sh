#!/bin/bash

# parser() {
#    local temp_name=""
#    local temp_extension=""
#    local remaining=0
#    local name=$1
#    local arr=()
#    for (( i=0; i < ${#name}; i++ )); do
#        if [ ${name:$i:1} == "." ]; then
#            remaining=$(( ${#name} - i - 1 ))
#            temp_extension+=${name:$i+1:$remaining}
#            break
#        fi
#        temp_name+="${name:$i:1}"
#    done
#    arr+=($temp_name)
#    arr+=($temp_extension)
#    echo ${arr[@]}
#}

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

create_file() {
    log_file="$1/info.log"
    echo "Directory path: $2" >> $log_file 
    echo "Directory date: $3" >> $log_file
    echo "File path: $4" >> $log_file
    echo "File date: $5" >> $log_file
    echo "File size: $6" >> $log_file
    echo "----------------------" >> $log_file
}

check_memory() {
    if [[ $(df --output=avail "$1" | tail -n 1) -lt $((1024*1024)) ]]; then
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

        while [[ ${#folder_name} -lt 4 ]]; do
            folder_name+="${folder_name: -1}"
        done
        
        local folder="${folder_name}_$(date +%d%m%y)"
        if [[ ! -d "$path/$folder" ]]; then
            echo "$folder"
            return 0
        fi
        ((attempt++))
    done

    echo "Error: Could not generate unique folder name" >&2
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

    echo "Error: Could not generate unique file name" >&2
    return 1
}

create_file_in_folder() {
    local dir="$1"
    local file_name="$2"
    local size=$3
    local numb_size=$(get_size $size)
    truncate -s "${numb_size}K" "$dir/$file_name"
}