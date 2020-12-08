#!/bin/bash
echo "hostssl replication all 0.0.0.0/0 md5 clientcert=1" >> "$PGDATA/pg_hba.conf"
set -e
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
CREATE USER $PG_REP_USER REPLICATION LOGIN CONNECTION LIMIT 100 ENCRYPTED PASSWORD '$PG_REP_PASSWORD';
EOSQL
cat >> ${PGDATA}/postgresql.conf <<EOF
wal_level = hot_standby
hot_standby = on
ssl = on

archive_mode = on
archive_command = 'cp %p /var/lib/postgresql/walarchive/%f'
max_wal_senders = 8
wal_keep_segments = 8

ssl_ca_file = '/var/lib/postgresql/certs/root.crt'
ssl_cert_file = '/var/lib/postgresql/certs/server.crt'
ssl_key_file = '/var/lib/postgresql/certs/server.key'
EOF