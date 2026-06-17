#!/bin/bash
# Runs once, on first DB initialization (empty data volume).
# Creates the target schema (if not "public") and loads the table structure.
set -e

SCHEMA="${DB_SCHEMA:-public}"

if [ "$SCHEMA" != "public" ]; then
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" \
    -c "CREATE SCHEMA IF NOT EXISTS \"$SCHEMA\";"
fi

# Replace the placeholder search_path line in the bundled SQL, then load it.
sed "s/SET search_path TO \[you schema there if need\], public;/SET search_path TO ${SCHEMA}, public;/" \
  /sql/cropio_api_structure.sql \
  | psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB"

echo "cropio-backupper: schema '${SCHEMA}' initialized."
