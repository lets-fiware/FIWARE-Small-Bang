#!/bin/bash
set -eu

cd "$(dirname "$0")"
cd ../..

if [ ! -e .env ]; then
  echo ".env file not fuond"
  exit 1
fi

. ./.env

ngsi hget \
  --host "${QUANTUMLEAP}" \
  --service openiot \
  --path / \
  entities
