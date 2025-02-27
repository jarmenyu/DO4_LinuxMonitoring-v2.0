#!/bin/bash

source ./arrays.sh

for ((i = 1; i < 6; i++)); do
  log_index=$((RANDOM % 901 + 100))
  for ((j = 0; j < $log_index; j++)); do 
    date=$(date '+%d/%b/%Y:%H:%M:%S %z') # время, когда запрос был сделан к серверу
    ip="$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))" # айпи пользователя, который отправил запрос на сервак
    method=$(printf "%s\n" "${methods[@]}" | shuf -n 1)
    url=$(printf "%s\n" "${urls[@]}" | shuf -n 1)
    response=$(printf "%s\n" "${responses[@]}" | shuf -n 1)
    url_absolute=$(printf "%s\n" "${urls_absolute[@]}" | shuf -n 1)
    agent=$(printf "%s\n" "${agents[@]}" | shuf -n 1)
    log="$ip - - [$date] \"$method $url HTTP/1.1\" \
$response $((RANDOM % 10000)) \"$url_absolute\" \"$agent\""
    echo -e "$log" >> "$i.log"
  done
done

