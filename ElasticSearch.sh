#!/bin/bash
    declare -a arr=("botevents" "apievents" "userevents" "messages")
    touch event.txt
    while :
    do
        echo $(date '+%H%M') >> event.txt
        if [ $(date '+%H%M') = '0100' ]
        then
          for i in "${arr[@]}"
            do
              ts=$(date +%d-%m-%Y_%H-%M-%S)
              elasticdump --input=http://elastic.esstack:9200/${i} --output=${i}_${ts}.json --type=data --searchBody="{\"query\": {\"range\": {\"@timestamp\": {\"gte\": \"now-1d/d\", \"lt\": \"now/d\"}}}}" --limit 1000
              aws s3 cp ${i}_${ts}.json s3://opteon-data-integration/
              echo "${i}_${ts}" >> event.txt
              rm ${i}_${ts}.json
            done
          sleep 60
        fi
        sleep 30
    done
