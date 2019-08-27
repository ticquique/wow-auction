#!/bin/bash
set -e

if [ "$WOW_SECRET" == "" ] || [ "$WOW_ID" == "" ]
then
  echo "No WOW_SECRET or WOW_ID provided ensure .env"
  exit 1;
fi

if [[ "$1" == "serve" ]]; then
    shift 1
    cron && tail -f /var/log/cron.log
else
    eval "$@"
fi

# prevent docker exit
tail -f /dev/null
