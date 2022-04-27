#!/bin/bash
TODAY=`date +"%d%b%Y"`
 
DB_BACKUP_PATH='/backup/mongo'
MONGO_HOST='localhost'
MONGO_PORT='27017'

MONGO_USER='root'
MONGO_PASSWD='c0mpl1cat3d'

# Set "ALL" for all DBs else, DB names seprated by space for specific dbs
 
#DATABASE_NAMES='ALL'
DATABASE_NAMES='vault'

mkdir -p ${DB_BACKUP_PATH}/${TODAY}
 
AUTH_PARAM=" --username ${MONGO_USER} --password ${MONGO_PASSWD} "

if [ ${DATABASE_NAMES} = "ALL" ]; then
 echo "You have choose to backup all databases"
 mongodump --host ${MONGO_HOST} --port ${MONGO_PORT} ${AUTH_PARAM} --out ${DB_BACKUP_PATH}/${TODAY}/
else
 echo "Running backup for selected databases"
 for DB_NAME in ${DATABASE_NAMES}
 do
 mongodump --host ${MONGO_HOST} --port ${MONGO_PORT} --db ${DB_NAME} ${AUTH_PARAM} --authenticationDatabase 'admin' -c authlogs --query '{ "timest": { "$gte": { "$date": "2010-08-19T00:00:00.000Z" } } }' --out ${DB_BACKUP_PATH}/${TODAY}/
 done
fi



#zip