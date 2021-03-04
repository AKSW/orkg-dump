#!/bin/sh

LC_ALL=C
DUMP=dump.nt
UNIQUE=unique.nt
EXPORT=orkg.nt
URL=https://orkg.org/orkg/api/rdf/dump

MESSAGE="Update ORKG Data"
LOG=""

curl -L $URL > $DUMP
LOG="${LOG}"$( date '+%Y-%m-%d %H.%M.%S%z' )"\n"
LOG="${LOG}"$( wc -l $DUMP )"\n"
sort -u $DUMP > $UNIQUE
LOG="${LOG}"$( wc -l $UNIQUE)"\n"
ERROR=$( { rapper -i ntriples -o ntriples $UNIQUE > $EXPORT; } 2>&1 )
LOG="${LOG}"$( wc -l $EXPORT )"\n"
rm $DUMP $UNIQUE
LOG="${LOG}${ERROR}\n"

LOG="${LOG}\nSource: \"<${URL}>\"\n"

echo $LOG

git add $EXPORT

# Check if files changed or commits need to be pushed
git status --porcelain | grep '^[MTD] '
change_status=$((1-$?))

if [ $change_status -eq 0 ]; then
  echo "[INFO] Repository needs no update. Abort."
  exit 0
else
  git commit -m "$MESSAGE" -m "$( echo ${LOG} )"
fi
