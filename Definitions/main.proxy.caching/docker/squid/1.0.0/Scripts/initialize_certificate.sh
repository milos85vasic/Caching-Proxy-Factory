#!/bin/sh

set -e

PEM="squid-proxy.pem"
SQUID_DIR="/etc/squid"
SSL_DB_DIR="/usr/local/squid/var/cache/squid/"
SSL_DB="$SSL_DB_DIR/ssl_db"
SQUID_LOG_DIR="/var/log/squid"
SQUID_CACHE_DIR="/var/cache/squid"
SSL_CERT_DIR="$SQUID_DIR/ssl_cert"

chown -R squid:squid "$SQUID_CACHE_DIR"
chown -R squid:squid "$SQUID_LOG_DIR"
chown -R squid:squid "$SSL_CERT_DIR"
chmod 755 "$SSL_CERT_DIR"

echo "Checking certificate"
if ! test -e "$SSL_CERT_DIR"/"$PEM"; then

  echo "Initializing new certificate"
  if openssl req -new -newkey rsa:2048 \
    -sha256 -days 365 -nodes -x509 -extensions v3_ca \
    -keyout "$SSL_CERT_DIR"/"$PEM" \
    -out "$SSL_CERT_DIR"/"$PEM" \
    -config "$SQUID_DIR"/openssl.cnf \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" &&
    mkdir -p "$SSL_DB_DIR" &&
    chown squid:squid -R "$SSL_DB_DIR" &&
    /usr/lib64/squid/security_file_certgen -c -s "$SSL_DB" -M 4MB &&
    chown squid:squid -R "$SSL_DB"; then

    echo "New certificate was initialized"
  else

    echo "ERROR: New certificate was not initialized"
    exit 1
  fi
else

  echo "Found existing certificate at $SSL_CERT_DIR/$PEM"
fi
