#!/bin/bash
TODAY=`date +"%d%b%Y"`
DB_BACKUP_PATH='/backup/mongodb_logs'
MONGO_HOST='localhost'
MONGO_PORT='27017'
MONGO_USER='root'
MONGO_PASSWD='c0mpl1cat3d'
mkdir -p ${DB_BACKUP_PATH}
AUTH_PARAM=" --username ${MONGO_USER} --password ${MONGO_PASSWD} "
LOGFILE=${DB_BACKUP_PATH}/logs.txt

# Set "ALL" for all DBs or DB names seprated by space for specific dbs

#DATABASE_NAMES='ALL'
DATABASE_NAMES='admin voice'

for DB_NAME in ${DATABASE_NAMES}
do
echo "Backup started for ${DB_NAME} at $(date +'%d-%m-%Y %H:%M:%S')" >> "$LOGFILE"
mongodump --host ${MONGO_HOST} --port ${MONGO_PORT}  --authenticationDatabase admin ${AUTH_PARAM} --db ${DB_NAME}
echo "Backup finished for ${DB_NAME} at $(date +'%d-%m-%Y %H:%M:%S')" >> "$LOGFILE"
done
mv dump ${TODAY}
tar -zcvf MongoDB_${TODAY}.tar.gz ${TODAY}
#aws s3 cp MongoDB_${TODAY}.tar.gz s3://opteon-data-integration/
echo "Successfully uploaded to AWS S3" >> "$LOGFILE"
#rm MongoDB_${TODAY}.tar.gz
#rm -rf ${TODAY}
echo "*****************" >> "$LOGFILE"


#Delete Files older than 3 days in AWS S3



