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
git commit -m "$MESSAGE" -m "$( echo ${LOG} )"
