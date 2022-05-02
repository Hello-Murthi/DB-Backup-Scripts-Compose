#!/bin/bash
TODAY=`date +"%d%b%Y"`
DB_BACKUP_PATH='/dbbackup/postgress'
mkdir -p ${DB_BACKUP_PATH}
mkdir ${TODAY}
LOGFILE=${DB_BACKUP_PATH}/backup_logs.txt

HOSTNAME='postgres'
USERNAME='postgres'
export PGPASSWORD="$DBPASSWD"

DATABASE='contacts postgres template0 template1'

for i in ${DATABASE}
do
    echo "Postgres dump started for ${i} at $(date +'%d-%m-%Y %H:%M:%S')" >> "$LOGFILE"
    pg_dump -h $HOSTNAME -p 5432 -U $USERNAME -d ${i} > ${i}.backup
    mv ${i}.backup ${TODAY}
    echo "Postgres dump finished for ${i} at $(date +'%d-%m-%Y %H:%M:%S')" >> "$LOGFILE"
done

tar -zcvf /${DB_BACKUP_PATH}/postgresbackup_${TODAY}.tar.gz ${TODAY}
rm -rf ${TODAY}

find ${DB_BACKUP_PATH} -type f -mtime +3 -name '*.gz' -delete

unset PGPASSWORD

echo "*****************" >> "$LOGFILE"


