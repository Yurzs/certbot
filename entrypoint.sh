#!/bin/sh

if ! test -f /etc/letsencrypt/dummy.pem; then
  openssl genrsa -out dummy.key 2048 >/dev/null 2>&1
  openssl req -new -key dummy.key -out dummy.csr -subj "/C=''/L=''/O=''/CN=''" >/dev/null 2>&1
  openssl x509 -req -days 3650 -in dummy.csr -signkey dummy.key -out dummy.crt >/dev/null 2>&1
  mv dummy.crt /etc/letsencrypt/dummy.pem
  rm dummy.key dummy.csr
fi

exec "$@"
