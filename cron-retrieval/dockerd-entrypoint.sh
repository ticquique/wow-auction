#!/bin/bash
set -e

if [ "$WOW_SECRET" == "" ] || [ "$WOW_ID" == "" ]
then
  echo "No WOW_SECRET or WOW_ID provided ensure .env"
  exit 1;
fi


echo "WOW secret: $WOW_SECRET"
echo "WOW id: $WOW_ID"

if [[ "$1" == "serve" ]]; then
  rm -rf /tmp/*
  cronjob="* * * * * bash /home/retriever.sh -s ${WOW_SECRET} -i ${WOW_ID}"
  echo "$cronjob" | crontab -
  cron start
  tail -f /var/log/cron.log
else
  eval "$@"
fi

# prevent docker exit
tail -f /dev/null
