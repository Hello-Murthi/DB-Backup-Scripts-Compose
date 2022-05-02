#!/bin/bash
TODAY=`date +"%d%b%Y"`
DB_BACKUP_PATH='/dbbackup/mongodb'
MONGO_HOST='mongodb'
MONGO_PORT='27017'
mkdir -p ${DB_BACKUP_PATH}
AUTH_PARAM=" --username ${DBUSER} --password ${DBPASSWD} "
LOGFILE=${DB_BACKUP_PATH}/backup_logs.txt

DATABASE_NAMES='admin agent ai assets audit botMapping config customer_data dashboard emailThreads local models notification settings support testing vault voice'

for DB_NAME in ${DATABASE_NAMES}
do
echo "Backup started for ${DB_NAME} at $(date +'%d-%m-%Y %H:%M:%S')" >> "$LOGFILE"
mongodump --forceTableScan --host ${MONGO_HOST} --port ${MONGO_PORT}  --authenticationDatabase admin ${AUTH_PARAM} --db ${DB_NAME}
echo "Backup finished for ${DB_NAME} at $(date +'%d-%m-%Y %H:%M:%S')" >> "$LOGFILE"
done
mv dump ${TODAY}

tar -zcvf /${DB_BACKUP_PATH}/mongodb_${TODAY}.tar.gz ${TODAY}

rm -rf ${TODAY}

find ${DB_BACKUP_PATH} -type f -mtime +3 -name '*.gz' -delete

echo "*****************" >> "$LOGFILE"

