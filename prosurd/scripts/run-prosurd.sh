#!/bin/bash

# Get script path. Log file path is expected to be next to prosur git root directory
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
LOG_FILE=$SCRIPT_DIR/../../../prosurd.log


# Start postgresql
echo "Starting postgres" | ts | tee -a $LOG_FILE
sudo su - postgres -c "/usr/local/pgsql/bin/pg_ctl start -l /usr/local/pgsql/var/log/pgsql.log -D /mnt/data/prosurd_db"

# Wait for postgresql
echo "Waiting postgres to launch on 5432..." | ts | tee -a $LOG_FILE
while ! nc -z localhost 5432; do   
	sleep 0.1
done
echo "Postgres launched" | ts | tee -a $LOG_FILE

# Wait for network. Ping the gateway.
GATEWAY=$(/sbin/ip route | awk '/default/ { print $3 }')
echo "Waiting for network gateway to come online..." | ts | tee -a $LOG_FILE
while ! ping -c 1 -W 1 $GATEWAY; do
	GATEWAY=$(/sbin/ip route | awk '/default/ { print $3 }')
    sleep 1
done
echo "Gateway online. Proceeding." | ts | tee -a $LOG_FILE

# Start prosurd
echo "Starting prosurd" | ts | tee -a $LOG_FILE
cd ${SCRIPT_DIR}/.. # PWD must be prosur/prosurd while launching

# Load config file
source scripts/run-prosurd.config

../../build_prosurd/prosurd $REPRAP_HOSTNAME &>> $LOG_FILE
echo "Prosurd completed" | ts | tee -a $LOG_FILE


3>&1