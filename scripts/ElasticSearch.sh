#!/bin/bash
TODAY=`date +"%d%b%Y"`
DB_BACKUP_PATH='/dbbackup/elasticsearch'

mkdir -p ${DB_BACKUP_PATH}
mkdir ${TODAY}

LOGFILE=${DB_BACKUP_PATH}/backup_logs.txt

declare -a arr=("x1646394621131_error_codes" "x1646394621131_faq_auto_suggestion" "x1646656077785_error_codes" "x1645605670754_user" "x1646656077785_issue_details" "x1646394621131_messageid_autosuggestion" "x1646394621131_issue_details" "x1646208940336_messageid_autosuggestion" "botevents" "x1646208940336_user_details" "x1646394621131_user_details" "userevents" "x1646208940336_messagetable" "x1646656077785_agent_feedback" "x1646394621131_messagetable" "x1646208940336_analytics" "documents_v2_x1646656077785" "documents_v2_x1646208940336" "alljourneys" "x1646656077785_messageid_autosuggestion" "x1646394621131_analytics" "x1646656077785_analytics" "x1646656077785_user_details" "entities" "x1646208940336_agent_feedback" "x1646208940336_faq_auto_suggestion" "x1646208940336_issue_details" "message_log" "x1646656077785_faq_auto_suggestion" "messages" "support_tickets" "botmetrics-events.bots.custom" "x1646208940336_error_codes" "ip2location" "mapping_errors" "documents_v2_x1646394621131")
for i in "${arr[@]}"
  do
    ts=$(date +%d-%m-%Y_%H-%M-%S)
    echo "Backup started for ${i} index at $(date +'%d-%m-%Y %H:%M:%S')" >> "$LOGFILE"
    elasticdump --input=http://elasticsearch:9200/${i} --type=data --searchBody="{\"query\": {\"range\": {\"@timestamp\": {\"gte\": \"now-1d/d\", \"lt\": \"now/d\"}}}}" --limit 1000 --output=${i}.json
    mv ${i}.json ${TODAY}
    echo "Backup finished for ${i} index at $(date +'%d-%m-%Y %H:%M:%S')" >> "$LOGFILE"
  done
tar -zcvf /${DB_BACKUP_PATH}/esbackup_${TODAY}.tar.gz ${TODAY}

rm -rf ${TODAY}

echo "*****************" >> "$LOGFILE"