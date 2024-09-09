#!/bin/sh

CRT_LIST_PATH="/usr/local/etc/haproxy/crts/crt.list"
DUMMY_CERT_PATH="/etc/letsencrypt/dummy/dummy.pem"

# Create a dummy pem file if it doesn't exist
if ! test -f "$DUMMY_CERT_PATH"; then
  openssl genrsa -out dummy.key 2048 >/dev/null 2>&1
  openssl req -new -key dummy.key -out dummy.csr -subj "/C=''/L=''/O=''/CN=''" >/dev/null 2>&1
  openssl x509 -req -days 3650 -in dummy.csr -signkey dummy.key -out dummy.crt >/dev/null 2>&1
  cat dummy.crt dummy.key > "$DUMMY_CERT_PATH"
  rm dummy.key dummy.csr dummy.crt
fi

# Create a dummy crt file if it doesn't exist
if ! test -f "$CRT_LIST_PATH"; then
  mkdir -p "$(dirname "$CRT_LIST_PATH")"
  echo -e "$DUMMY_CERT_PATH\n" > "$CRT_LIST_PATH"
fi

export CRT_LIST_PATH="$CRT_LIST_PATH"
export DUMMY_CERT_PATH="$DUMMY_CERT_PATH"

exec "$@"
