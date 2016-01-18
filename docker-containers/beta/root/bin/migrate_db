#!/bin/bash
if [ -z "$1" ]; then
  echo "Old Database location not supplied"
  exit 1
else
  OLD_DB_LOCATION=$1
fi

if [ -z "$2" ]; then
  echo "New Database location not supplied"
  exit 1
else
  NEW_DB_LOCATION=$2
fi

if [ -z "$3" ]; then
  echo "Database location not supplied"
  exit 1
else
  DB_LOCATION=$3
fi

rm /var/lib/emby-server/data/library.db-shm
rm /var/lib/emby-server/data/library.db-wal
sqlite3 $DB_LOCATION  "UPDATE TypedBaseItems SET data = CAST(REPLACE(CAST(data AS TEXT), '$OLD_DB_LOCATION', '$NEW_DB_LOCATION') AS BLOB)"
