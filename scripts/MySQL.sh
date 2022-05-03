#!/bin/bash

TODAY=`date +"%d%b%Y"`
BACKUP_PATH='/dbbackup/mysql'
mkdir -p ${BACKUP_PATH}
mkdir MySQL_${TODAY}
LOGFILE=${BACKUP_PATH}/logs.txt

DATABASE_NAMES='ym'

for DB_NAME in ${DATABASE_NAMES}
do
    echo "Backup started for ${DB_NAME} at $(date +'%d-%m-%Y %H:%M:%S')" >> ${LOGFILE}
    mysqldump --host=mysql --port=3306 --user=${USER} --password=${PASSWORD} --default-character-set=utf8 --column-statistics=0 ${DB_NAME} > ${DB_NAME}.sql
    mv ${DB_NAME}.sql MySQL_${TODAY}
    echo "Backup finished for ${DB_NAME} at $(date +'%d-%m-%Y %H:%M:%S')" >> ${LOGFILE}
    echo " " >> ${LOGFILE}
done

tar -zcvf /${BACKUP_PATH}/MySQL_${TODAY}.tar.gz MySQL_${TODAY}
rm -rf MySQL_${TODAY}
find ${BACKUP_PATH} -type f -mtime +3 -name '*.gz' -delete

echo "*****************" >> ${LOGFILE}
