#!/bin/bash

TODAY=`date +"%d%b%Y"`
BACKUP_PATH='/dbbackup/mongodb'
mkdir -p ${BACKUP_PATH}
LOGFILE=${BACKUP_PATH}/logs.txt

HOST='mongodb'
PORT='27017'
AUTH_PARAM=" --username ${USER} --password ${PASSWORD} "

DATABASE_NAMES='admin agent ai assets audit botMapping config customer_data dashboard emailThreads local models notification settings support testing vault voice'

for DB_NAME in ${DATABASE_NAMES}
do
  echo "Backup started for ${DB_NAME} at $(date +'%d-%m-%Y %H:%M:%S')" >> ${LOGFILE}
  mongodump --forceTableScan --host ${HOST} --port ${PORT}  --authenticationDatabase admin ${AUTH_PARAM} --db ${DB_NAME}
  echo "Backup finished for ${DB_NAME} at $(date +'%d-%m-%Y %H:%M:%S')" >> ${LOGFILE}
  echo " " >> ${LOGFILE}
done

mv dump MongoDB_${TODAY}
tar -zcvf /${BACKUP_PATH}/MongoDB_${TODAY}.tar.gz MongoDB_${TODAY}
rm -rf MongoDB_${TODAY}
find ${BACKUP_PATH} -type f -mtime +3 -name '*.gz' -delete

echo "*****************" >> ${LOGFILE}

