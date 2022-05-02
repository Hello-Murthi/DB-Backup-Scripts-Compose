#!/bin/bash
TODAY=`date +"%d%b%Y"`
DB_BACKUP_PATH='/dbbackup/mysql'
mkdir -p ${DB_BACKUP_PATH}
mkdir ${TODAY}
LOGFILE=${DB_BACKUP_PATH}/backup_logs.txt

DATABASE_NAMES='ym'

for DB_NAME in ${DATABASE_NAMES}
do
    echo "MySql dump started for ${DB_NAME} at $(date +'%d-%m-%Y %H:%M:%S')" >> "$LOGFILE"
    mysqldump --column-statistics=0 --host=mysql --port=3306 --user=${DBUSER} --password=${DBPASSWD} --default-character-set=utf8  ${DB_NAME} > ${DB_NAME}.sql
    mv ${DB_NAME}.sql ${TODAY}
    echo "MySql dump finished for ${DB_NAME} at $(date +'%d-%m-%Y %H:%M:%S')" >> "$LOGFILE"

done

tar -zcvf /${DB_BACKUP_PATH}/mysqlbackup_${TODAY}.tar.gz ${TODAY}
rm -rf ${TODAY}

find ${DB_BACKUP_PATH} -type f -mtime +3 -name '*.gz' -delete

echo "*****************" >> "$LOGFILE"
