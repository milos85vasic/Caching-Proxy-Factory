#!/bin/sh

set -e

SQUID_CONF=/etc/squid/squid.conf

echo "Checking cache..."
if ! test -e "$SQUID_CACHE_DIR"/00; then

    echo "No existing cache found. Initializing new cache..."
    squid -N -f ${SQUID_CONF} -z
else
    echo "Found existing cache at ${SQUID_CACHE_DIR}"
fi

echo "Starting Squid..."
squid -f ${SQUID_CONF} -NYCd 1