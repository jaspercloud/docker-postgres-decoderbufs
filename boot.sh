#!/bin/bash

chown -R postgres:postgres /var/lib/postgresql

if [ ! -d "${PGDATA}/postgresql.conf" ]; then
   su - postgres -c "mkdir -p ${PGDATA}"
   su - postgres -c "initdb -D ${PGDATA} --pwfile=<(echo '$POSTGRES_PASSWORD')"
   su - postgres -c "echo 'host all all all md5' >> /var/lib/postgresql/data/pg_hba.conf"
fi

su - postgres -c "postgres -D ${PGDATA}"

