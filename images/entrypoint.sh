#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-web}"

ZEO_PORT="${ZEO_PORT:-8100}"
HTTP_PORT="${HTTP_PORT:-8080}"
ZEO_ADDRESS="${ZEO_ADDRESS:-127.0.0.1:${ZEO_PORT}}"

PLONE_SITE="${PLONE_SITE:-Plone}"
PASSWORD="${PASSWORD:-admin}"
ADDONS="${ADDONS:-senaite.storage senaite.jsonapi senaite.impress senaite.databox}"
ZEO_SHARED_BLOB_DIR="${ZEO_SHARED_BLOB_DIR:-off}"
ZEO_CLIENT_CACHE_SIZE="${ZEO_CLIENT_CACHE_SIZE:-512MB}"

cd /opt/senaite

# patch ports in generated configs (safe even if already patched)
ZEO_CONF="/opt/senaite/parts/zeoserver/etc/zeo.conf"
if [[ -f "$ZEO_CONF" ]]; then
  sed -ri "s/(address )([0-9.]+:)?[0-9]+/\1 0.0.0.0:${ZEO_PORT}/" "$ZEO_CONF" || true
fi

# patch instance http address + zeo address
for f in /opt/senaite/parts/instance/etc/zope.conf /opt/senaite/parts/instance/etc/wsgi.ini; do
  [[ -f "$f" ]] || continue
  sed -ri "s/(http-address = ).*/\1 0.0.0.0:${HTTP_PORT}/" "$f" || true
  sed -ri "s/(address )([0-9.]+:)?[0-9]+/\1 ${ZEO_ADDRESS}/" "$f" || true
done

# data perms (avoid volume pain)
mkdir -p /data /data/blobstorage /data/cache /data/backups || true
chmod -R 770 /data || true

export ZEO_ADDRESS PLONE_SITE PASSWORD ADDONS ZEO_SHARED_BLOB_DIR ZEO_CLIENT_CACHE_SIZE

if [[ "$MODE" == "zeo" ]]; then
  exec /opt/senaite/bin/zeoserver fg
elif [[ "$MODE" == "web" ]]; then
  exec /opt/senaite/bin/instance fg
else
  echo "Uso: entrypoint.sh {zeo|web}"
  exit 2
fi
