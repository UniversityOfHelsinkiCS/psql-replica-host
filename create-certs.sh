#!/bin/bash

REP_USER=rep

#rm certs/* && rm clientcerts/* && \
openssl genrsa -des3 -passout pass:1234 -out certs/server.key 1024 && \
openssl rsa -passin pass:1234 -in certs/server.key -out certs/server.key && \
openssl req -new -key certs/server.key -days 3650 -out certs/server.crt -x509 -subj '/C=FI/ST=Uusimaa/L=Helsinki/O=toska.dev/CN=toska.dev/emailAddress=grp-toska@helsinki.fi' && \
cp certs/server.crt certs/root.crt && \
openssl genrsa -des3 -passout pass:1234 -out clientcerts/postgresql.key 1024 && \
openssl rsa -passin pass:1234 -in clientcerts/postgresql.key -out clientcerts/postgresql.key && \
openssl req -new -key clientcerts/postgresql.key -out clientcerts/postgresql.csr -subj '/C=FI/ST=Uusimaa/L=Helsinki/O=toska.dev/CN=$REP_USER/emailAddress=grp-toska@helsinki.fi' && \
openssl x509 -req -in clientcerts/postgresql.csr -CA certs/root.crt -CAkey certs/server.key -days 3650 -out clientcerts/postgresql.crt -CAcreateserial && \
cp certs/root.crt clientcerts/root.crt;
