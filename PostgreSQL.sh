#!/bin/bash

HOSTNAME='localhost'
USERNAME='root'
PASSWORD='c0mpl1cat3d'
DATABASE=

# Note that we are setting the password to a global environment variable temporarily.
echo "Pulling Database: This may take a few minutes"
export PGPASSWORD="$PASSWORD"
pg_dump -F t -h $HOSTNAME -U $USERNAME $DATABASE > $(date +%Y-%m-%d).backup
unset PGPASSWORD
echo "Pull Complete"


#db, date, zip