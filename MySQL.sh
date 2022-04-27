#!/bin/sh

now="$(date +'%d_%m_%Y_%H_%M_%S')"
filename="db_backup_$now"
DB_BACKUP_PATH='/MySQL'
mkdir -p ${DB_BACKUP_PATH}
fullpathbackupfile="$DB_BACKUP_PATH/$filename"

echo "mysqldump started at $(date +'%d-%m-%Y %H:%M:%S')"
mysqldump --user=root --password=c0mpl1cat3d --default-character-set=utf8 ym > "$fullpathbackupfile"
echo "mysqldump finished at $(date +'%d-%m-%Y %H:%M:%S')"
exit 0



#date