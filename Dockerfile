FROM postgres:13.1

COPY ./certs/* /var/lib/postgresql/certs/

RUN chown -R postgres:postgres /var/lib/postgresql/certs/
RUN chmod 600 /var/lib/postgresql/certs/*

COPY ./setup-host.sh /docker-entrypoint-initdb.d/setup-host.sh
RUN chmod 0666 /docker-entrypoint-initdb.d/setup-host.sh