#!/bin/bash
TODAY=`date +"%d%b%Y"`
DB_BACKUP_PATH='/backup/elasticsearch'
mkdir -p ${DB_BACKUP_PATH}/${TODAY}
LOGFILE=${DB_BACKUP_PATH}/logs.txt

declare -a arr=("userevents" "botevents")
touch event.txt
for i in "${arr[@]}"
  do
    ts=$(date +%d-%m-%Y_%H-%M-%S)
    echo "Backup started for ${i} index at $(date +'%d-%m-%Y %H:%M:%S')" >> "$LOGFILE"
    elasticdump --input=http://localhost:9200/${i} --type=data --searchBody="{\"query\": {\"range\": {\"@timestamp\": {\"gte\": \"now-1d/d\", \"lt\": \"now/d\"}}}}" --limit 1000 --output=$ | gzip > ${DB_BACKUP_PATH}/${TODAY}/${i}_${ts}.json.gz
    echo "File Path: ${DB_BACKUP_PATH}/${TODAY}/${i}_${ts}.json.gz" >> "$LOGFILE"
    echo "Backup finished for ${i} index at $(date +'%d-%m-%Y %H:%M:%S')" >> "$LOGFILE"
    #aws s3 cp ${DB_BACKUP_PATH}/${TODAY}/${i}_${ts}.json.gz s3://opteon-data-integration/
    echo "*****************" >> "$LOGFILE"
    #rm ${DB_BACKUP_PATH}/${TODAY}/${i}_${ts}.json.gz
  done
sleep 60


