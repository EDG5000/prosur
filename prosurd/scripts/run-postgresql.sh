#!/bin/bash

su - postgres -c "/usr/local/pgsql/bin/pg_ctl start -l /usr/local/pgsql/var/log/pgsql.log -D /mnt/data/prosurd_db"
