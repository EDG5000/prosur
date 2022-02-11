#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
LOG_FILE=$SCRIPT_DIR/../../../prosurd.log

cd ${SCRIPT_DIR}/..

echo "Starting postgres" | ts | tee -a $LOG_FILE

su - postgres -c "/usr/local/pgsql/bin/pg_ctl start -l /usr/local/pgsql/var/log/pgsql.log -D /mnt/data/prosurd_db"

echo "Waiting postgres to launch on 5432..." | ts | tee -a $LOG_FILE

while ! nc -z localhost 5432; do   
  sleep 0.1
done

echo "Postgres launched" | ts | tee -a $LOG_FILE

echo "Starting prosurd" | ts | tee -a $LOG_FILE

../../build_prosurd/prosurd |& ts | tee -a $LOG_FILE

echo "Prosurd completed" | ts | tee -a $LOG_FILE