#!/bin/bash

if [ -f "openssl.conf" ]; then
  openssl req -new -x509 -key server.key -subj "/CN=ufleet" -config openssl.conf -days 3650 -out ca.crt
  openssl req -new -key server.key -subj "/CN=ufleet" -config openssl.conf  -out server.csr
  openssl x509 -req -days 3650 -in server.csr -CA ca.crt -CAkey server.key -CAcreateserial -extensions v3_req -extfile openssl.conf -out server.crt
  mv openssl.conf openssl.conf.bak
fi
