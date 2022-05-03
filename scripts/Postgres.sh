#!/bin/bash

TODAY=`date +"%d%b%Y"`
BACKUP_PATH='/dbbackup/postgres'
mkdir -p ${BACKUP_PATH}
mkdir Postgres_${TODAY}
LOGFILE=${BACKUP_PATH}/logs.txt

HOST='postgres'
USER='postgres'
export PGPASSWORD=${PASSWORD}

DATABASE_NAMES='contacts postgres template1'

for DB_NAME in ${DATABASE_NAMES}
do
    echo "Backup started for ${DB_NAME} at $(date +'%d-%m-%Y %H:%M:%S')" >> ${LOGFILE}
    pg_dump -h $HOST -p 5432 -U $USER -d ${DB_NAME} > ${DB_NAME}.backup

    if [ "$?" -eq 0 ]; then
        mv ${DB_NAME}.backup Postgres_${TODAY}
    else
        echo "ERROR: ${DB_NAME}.backup has failed, please check..." >> ${LOGFILE}
    fi
    
    echo "Backup finished for ${DB_NAME} at $(date +'%d-%m-%Y %H:%M:%S')" >> ${LOGFILE}
    echo " " >> ${LOGFILE}
done

tar -zcvf /${BACKUP_PATH}/Postgres_${TODAY}.tar.gz Postgres_${TODAY}
rm -rf Postgres_${TODAY}
find ${BACKUP_PATH} -type f -mtime +3 -name '*.gz' -delete
unset PGPASSWORD

echo "*****************" >> ${LOGFILE}


