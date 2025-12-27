#!/usr/bin/env bash
set -euo pipefail

MODE="${1:-web}"

cd /opt/senaite

if [[ "$MODE" == "zeo" ]]; then
  exec bin/zeoserver fg
elif [[ "$MODE" == "web" ]]; then
  exec bin/instance fg
else
  echo "Uso: $0 {zeo|web}"
  exit 2
fi
