FROM postgres:9.6.3

RUN mkdir /var/lib/postgresql/walarchive/

COPY ./certs/* /var/lib/postgresql/certs/

RUN chown -R postgres:postgres /var/lib/postgresql/walarchive/
RUN chown -R postgres:postgres /var/lib/postgresql/certs/
RUN chmod 600 /var/lib/postgresql/certs/*



COPY ./setup-host.sh /docker-entrypoint-initdb.d/setup-host.sh
RUN chmod 0666 /docker-entrypoint-initdb.d/setup-host.sh