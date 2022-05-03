#!/bin/bash

TODAY=`date +"%d%b%Y"`
BACKUP_PATH='/dbbackup/elasticsearch'
mkdir -p ${BACKUP_PATH}
mkdir ES_${TODAY}
LOGFILE=${BACKUP_PATH}/logs.txt

INDEX_NAMES='botevents userevents alljourneys entities message_log messages support_tickets ip2location mapping_errors'

for INDEX in ${INDEX_NAMES}
do
  echo "Backup started for ${INDEX} index at $(date +'%d-%m-%Y %H:%M:%S')" >> ${LOGFILE}
  elasticdump --input=http://elasticsearch:9200/${INDEX} --type=data --searchBody="{\"query\": {\"range\": {\"@timestamp\": {\"gte\": \"now-1d/d\", \"lt\": \"now/d\"}}}}" --limit 1000 --output=${INDEX}.json
  
  if [ -e ${INDEX}.json ]; then
    mv ${INDEX}.json ES_${TODAY}
  else
    echo "ERROR: ${INDEX}.json file doesn't exist, please check..." >> ${LOGFILE}
  fi
  
  echo "Backup finished for ${INDEX} index at $(date +'%d-%m-%Y %H:%M:%S')" >> ${LOGFILE}
  echo " " >> ${LOGFILE}
done

tar -zcvf /${BACKUP_PATH}/ES_${TODAY}.tar.gz ES_${TODAY}
rm -rf ES_${TODAY}

echo "*****************" >> ${LOGFILE}