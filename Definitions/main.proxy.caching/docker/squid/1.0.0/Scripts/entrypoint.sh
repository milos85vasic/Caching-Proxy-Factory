#!/bin/sh

set -e

PROXY_USER="$1"
PROXY_USER_PASSWORD="$2"
SQUID_CONF="/etc/squid/squid.conf"
SQUID_CACHE_DIR="/var/cache/squid"

echo "Checking cache"
if ! test -e "$SQUID_CACHE_DIR"/00; then

  echo "No existing cache found. Initializing new cache"
  squid -N -f "$SQUID_CONF" -z
else

  echo "Found existing cache at $SQUID_CACHE_DIR"
fi

passwords=/etc/squid/passwords
if ! test -e "$passwords"; then

  mkdir -p "$passwords"
fi

chown -R squid:squid "$passwords" &&
  chmod 440 "$passwords"

accounts="$passwords"/accounts
if ! test -e "$accounts"; then

  htpasswd -c -b "$accounts" "$PROXY_USER" "$PROXY_USER_PASSWORD"
fi

if ! test -e "$accounts"; then

  echo "ERROR: $accounts is unavailable"
  exit 1
fi

echo "Checking user accounts"
result=$(echo "$PROXY_USER $PROXY_USER_PASSWORD" | /usr/lib64/squid/basic_ncsa_auth "$accounts")
if echo "$result" | grep "OK" >/dev/null 2>&1; then

  echo "Starting Squid"
  squid -f "$SQUID_CONF" -NYCd 1
else

  echo "ERROR: checking user accounts failed"
  exit 1
fi
