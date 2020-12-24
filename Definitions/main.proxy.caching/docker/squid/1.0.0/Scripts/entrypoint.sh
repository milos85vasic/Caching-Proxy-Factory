#!/bin/sh
set -e

SQUID_CACHE_DIR=/var/cache/squid
SQUID_LOG_DIR=/var/log/squid
SQUID_CONF=/etc/squid/squid.conf
SSL_CERT_DIR=/etc/squid/ssl_cert

chown -R squid:squid ${SQUID_CACHE_DIR}
chown -R squid:squid ${SQUID_LOG_DIR}
chown -R squid:squid ${SSL_CERT_DIR}
chmod 755 ${SSL_CERT_DIR}

echo "Checking certificate..."
if ! test -e "$SSL_CERT_DIR"/squid-proxy.pem; then

    echo "No certificate file found. Initializing new certificate..."
    openssl req -new -newkey rsa:2048 \
    -sha256 -days 365 -nodes -x509 -extensions v3_ca \
    -keyout ${SSL_CERT_DIR}/squid-proxy.pem  \
    -out ${SSL_CERT_DIR}/squid-proxy.pem \
    -config ${SSL_CERT_DIR}/openssl.cnf \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com"
    /usr/lib/squid/ssl_crtd -c -s /var/lib/ssl_db
    chown squid:squid -R /var/lib/ssl_db
else

    echo "Found existing certificate at ${SSL_CERT_DIR}/squid-proxy.pem"
fi

echo "Checking cache..."
if ! test -e "$SQUID_CACHE_DIR"/00; then

    echo "No existing cache found. Initializing new cache..."
    squid -N -f ${SQUID_CONF} -z
else
    echo "Found existing cache at ${SQUID_CACHE_DIR}"
fi

echo "Starting Squid..."
squid -f ${SQUID_CONF} -NYCd 1