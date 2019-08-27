#!/bin/bash
secret=$WOW_SECRET
id=$WOW_ID

output='/home/results'
while getopts ":i:s:o:" arg; do
  case $arg in
    s) secret=$OPTARG;;
    i) id=$OPTARG;;
    o) output=$OPTARG;;
  esac
done

echo "WOW secret: $secret" >> /var/log/cron.log 2>&1
echo "WOW id: $id" >> /var/log/cron.log 2>&1

date=`date +"%Y-%m-%d %H:%M:%S"`
token=`curl -u ${id}:${secret} -d grant_type=client_credentials https://eu.battle.net/oauth/token | jq -j '.access_token'`
# europe=("shazzrah" "flamelash" "gandling" "razorgore" "firemaw" "gehennas" "golemag" "mograine")
europe=("tyrande" "exodar")
for i in "${europe[@]}"; do   # The quotes are necessary here
    url=`curl --header "Authorization: Bearer ${token}" https://eu.api.blizzard.com/wow/auction/data/$i?locale=en_US | jq -j .files[0].url`
    curl $url > "${output}/auction_${i}_${date}.json"
    echo "Created file ${output}/auction_${i}_${date}.json from ${url}" >> /var/log/cron.log 2>&1
done
