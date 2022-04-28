#!/bin/bash
TODAY=`date +"%d%b%Y"`
DB_BACKUP_PATH='/backup/elasticdump_logs'
mkdir -p ${DB_BACKUP_PATH}
mkdir ${TODAY}
LOGFILE=${DB_BACKUP_PATH}/logs.txt

declare -a arr=("userevents" "botevents")
for i in "${arr[@]}"
  do
    ts=$(date +%d-%m-%Y_%H-%M-%S)
    echo "Backup started for ${i} index at $(date +'%d-%m-%Y %H:%M:%S')" >> "$LOGFILE"
    elasticdump --input=http://localhost:9200/${i} --type=data --searchBody="{\"query\": {\"range\": {\"@timestamp\": {\"gte\": \"now-1d/d\", \"lt\": \"now/d\"}}}}" --limit 1000 --output=${i}.json
    mv ${i}.json ${TODAY}
    echo "Backup finished for ${i} index at $(date +'%d-%m-%Y %H:%M:%S')" >> "$LOGFILE"
  done
tar -zcvf esbackup_${TODAY}.tar.gz ${TODAY}
#aws s3 cp esbackup_${TODAY}.tar.gz s3://opteon-data-integration/
echo "Successfully uploaded to AWS S3" >> "$LOGFILE"

rm esbackup_${TODAY}.tar.gz
rm -rf ${TODAY}
echo "*****************" >> "$LOGFILE"