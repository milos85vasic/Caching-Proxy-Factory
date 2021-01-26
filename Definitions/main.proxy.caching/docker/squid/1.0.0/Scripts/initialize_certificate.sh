#!/bin/sh

set -e

CITY="$4"
DOMAIN="$1"
COUNTRY="$2"
PROVINCE="$3"
DEPARTMENT="$5"
CA_FILE="$6"

SQUID_DIR="/etc/squid"
PEM="ssl_cert/$CA_FILE"
SSL_DB_DIR="/var/lib/squid"
SSL_DB="$SSL_DB_DIR/ssl_db"
SQUID_LOG_DIR="/var/log/squid"
SQUID_CACHE_DIR="/var/cache/squid"

chown -R squid:squid "$SQUID_LOG_DIR"
chown -R squid:squid "$SQUID_CACHE_DIR"

echo "Checking certificate existence: $PEM"
if ! test -e "$SQUID_DIR"/"$PEM"; then

  echo "Initializing new self-signed certificate"
  # TODO: MSF-392
  if openssl req -new -newkey rsa:2048 \
    -days 365 -nodes -x509 \
    -keyout "$SQUID_DIR"/"$PEM" \
    -out "$SQUID_DIR"/"$PEM" \
    -subj "/C=$COUNTRY/ST=$PROVINCE/L=$CITY/O=$DEPARTMENT/CN=$DOMAIN" &&
    openssl x509 -in "$SQUID_DIR"/"$PEM" -outform DER -out "$SQUID_DIR"/squid.der &&
    chown squid:squid "$SQUID_DIR"/"$PEM" &&
    chmod 444 "$SQUID_DIR"/"$PEM" &&
    mkdir -p "$SSL_DB_DIR" &&
    chown -R squid:squid "$SSL_DB_DIR" &&
    /usr/lib64/squid/security_file_certgen -c -s "$SSL_DB" -M 4MB &&
    chown -R squid:squid "$SSL_DB"; then

    echo "New certificate was initialized"
  else

    echo "ERROR: New certificate was not initialized"
    exit 1
  fi
else

  echo "Found existing certificate at $SQUID_DIR/$PEM"
fi
