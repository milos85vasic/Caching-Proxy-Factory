#!/bin/sh

set -e

SQUID_CONF="/etc/squid/squid.conf"
SQUID_CACHE_DIR="/var/cache/squid"

echo "Checking cache"
if ! test -e "$SQUID_CACHE_DIR"/00; then

  echo "No existing cache found. Initializing new cache"
  squid -N -f "$SQUID_CONF" -z
else

  echo "Found existing cache at $SQUID_CACHE_DIR"
fi

echo "Checking user accounts"
if /usr/lib64/squid/basic_ncsa_auth /etc/squid/passwords/accounts; then

  echo "Starting Squid"
  squid -f "$SQUID_CONF" -NYCd 1
else

  echo "ERROR: checking user accounts failed"
  exit 1
fi
