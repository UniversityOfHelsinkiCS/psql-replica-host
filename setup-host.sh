#!/bin/bash
echo "hostssl replication all 0.0.0.0/0 md5 clientcert=1" >> "$PGDATA/pg_hba.conf"
set -e
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
CREATE USER $PG_REP_USER REPLICATION LOGIN CONNECTION LIMIT 100 ENCRYPTED PASSWORD '$PG_REP_PASSWORD';
select pg_create_physical_replication_slot('$REP_SLOT_NAME');
EOSQL
cat >> ${PGDATA}/postgresql.conf <<EOF
ssl = on
wal_keep_size = 1000
max_slot_wal_keep_size = 5000
ssl_ca_file = '/var/lib/postgresql/certs/root.crt'
ssl_cert_file = '/var/lib/postgresql/certs/server.crt'
ssl_key_file = '/var/lib/postgresql/certs/server.key'
EOF